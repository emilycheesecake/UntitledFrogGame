extends KinematicBody2D

onready var global = get_node("/root/Global")

var velocity = Vector2.ZERO
var is_jumping = false
var can_wall_jump = true
var on_wall = false
var jump_strength = 0.0
var start_position = Vector2(50, -50)
var max_health = 6
var invulnerable = false
var score = 0
var hop_sound = preload("res://assets/sounds/hop.wav")
var jump_sound = preload("res://assets/sounds/jump.wav")
var attack_sound = preload("res://assets/sounds/slap.wav")
var death_sound = preload("res://assets/sounds/wobbledown.wav")

export(PackedScene) var attack_hitbox
export var attacking = false
export var can_move = true
export var is_dead = false
export var speed = 50
export var gravity = 200.0
export var jump_height = 200
export var death_height = 48
export var health = 6
export var lives = 3

func _ready():
	$InvulnTimer.stop()
	position = start_position

func _input(event):
	if not global.paused:
		# Jump when action is released
		if event.is_action_released("jump") and (is_on_floor() or is_touching_wall()):
			# Small jump sound effect
			$AudioStreamPlayer.stream = hop_sound
			$AudioStreamPlayer.play()
			jump()
		if event.is_action_pressed("attack"):
			start_attack()

func _physics_process(delta):
	if not global.paused:
		# Handle player input and physics if they are not dead
		if not is_dead:
			# Gravity
			velocity.y += delta * gravity
			# Player Movement
			if Input.is_action_pressed("move_right"):
				velocity.x = speed
				$Sprite.flip_h = false
				$WallJumpTrigger.position.x = position.x - 5
				if not is_jumping:
					$AnimationTree.set("parameters/isWalking/current", 1)
			elif Input.is_action_pressed("move_left"):
				velocity.x = -speed
				$Sprite.flip_h = true
				$WallJumpTrigger.position.x = position.x + 5
				if not is_jumping:
					$AnimationTree.set("parameters/isWalking/current", 1)
			else:
				velocity.x = 0
				# Change animation to idle if no horizontal movement and on ground
				if is_on_floor():
					$AnimationTree.set("parameters/isWalking/current", 0)
			
			if is_on_floor() and is_jumping and !can_wall_jump:
				can_wall_jump = true
			
			if is_touching_wall() and can_wall_jump:
				if Input.is_action_pressed("jump"):
					jump_strength = jump_height * 4
					jump()
					velocity.x += 16 if not $Sprite.flip_h else -16
					can_wall_jump = false
			
			if is_on_floor():
				can_wall_jump = false
				# Charge jump when held
				if Input.is_action_pressed("jump"):
					charge_jump(delta)
					
			if (is_on_floor() or is_touching_wall()):
				is_jumping = false
				$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_IDLE
			else:
				jump_strength = 0
				global.update_jump_strength(jump_strength)
				
			# Update health UI
			global.update_health(health)
			velocity = move_and_slide(velocity, Vector2(0, -1))
	else:
		# Change process mode to manual when game is paused
		$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_MANUAL

func charge_jump(delta):
	# Show and fill jump meter
	if jump_strength < jump_height:
		$AnimationTree.set("parameters/jumpPrep/current", 1)
		velocity.x /= 2
		jump_strength += delta * 200 # Speed that jump charges
		$AnimationTree.set("parameters/isWalking/current", 0) 
		global.update_jump_strength(jump_strength)
	# Jump automatically when jump meter fills
	if jump_strength >= jump_height:
		#Sound Effect
		$AudioStreamPlayer.stream = jump_sound
		$AudioStreamPlayer.play()
		jump()

func jump():
	if !is_dead:
		if is_on_floor():
			velocity.y = -jump_strength
		elif is_touching_wall():
			print("walljump attempts")
			velocity.y = -jump_strength * 4
		$AnimationTree.set("parameters/jumpPrep/current", 0)
		$AnimationTree.set("parameters/isJumping/active", true)
		is_jumping = true
		jump_strength = 0.0
		global.update_jump_strength(jump_strength)
		$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_MANUAL
		$Sprite.frame = 17

func start_attack():
	$AnimationTree.set("parameters/isAttacking/active", true)

func attack():
	var closest_dude
	for b in $AttackRange.get_overlapping_bodies():
		if "Dude" in b.name:
			if !closest_dude:
				closest_dude = b
			if position.distance_to(b.position) < position.distance_to(closest_dude.position):
				closest_dude = b
			b.hit(Vector2(0, 0))
	$Tongue.clear_points()
	if closest_dude != null:
		# Sound Effect
		$AudioStreamPlayer.stream = attack_sound
		$AudioStreamPlayer.play()
		$Tongue.add_point($Sprite.position)
		$Tongue.add_point($Tongue.to_local(closest_dude.position))
		$TongueTimer.start()

func spawn_attack_hitbox():
	var i = attack_hitbox.instance()
	i.position = Vector2($Sprite.position.x - 8, $Sprite.position.y) if $Sprite.flip_h else Vector2($Sprite.position.x + 8, $Sprite.position.y)
	add_child(i)

func clear_tongue_points():
	$Tongue.clear_points()

func hurt():
	if not invulnerable:
		if health > 1:
			health -= 1
			global.update_health(health)
			$AnimationTree.set("parameters/isHit/active", true)
			invulnerable = true
		else:
			die()
		$InvulnTimer.start()
	
func die():
	velocity = Vector2.ZERO
	is_dead = true
	global.stop_music()
	$AudioStreamPlayer.stream = death_sound
	$AudioStreamPlayer.play()
	is_jumping = false
	$AnimationTree.set("parameters/isDead/active", true)
	
func death_reset():
	if lives <= 1:
		global.game_over()
	
	global.transition_out()
	yield(global.get_node("UI/CircleTransition/AnimationPlayer"), "animation_finished")
	position = start_position
	is_dead = false
	$AnimationTree.set("parameters/isDead/active", false)
	$Sprite.position.y = 0
	health = max_health
	global.update_health(health)
	# Update lives
	lives -= 1
	global.update_life(lives)
	if global.music:
		global.start_music()
	global.transition_in()

func reset():
	position = Vector2(0, -1000)
	lives = 3
	global.update_life(lives)
	score = 0
	global.update_score(score)
	health = max_health
	global.update_health(health)

func update_health(amount):
	if health < max_health:
		health += amount
		global.update_health(health)

func is_touching_wall() -> bool:
	return is_on_wall() or on_wall

func _on_InvulnTimer_timeout():
	invulnerable = false
	$Sprite.material.set_shader_param("active", false)
	$InvulnTimer.stop()


func _on_TongueTimer_timeout():
	clear_tongue_points()
	$TongueTimer.stop()


func _on_WallJumpTrigger_body_entered(body):
	if "Tilemap" in body.name and not is_on_floor():
		print("wall jump trigger")
		on_wall = true


func _on_WallJumpTrigger_body_exited(body):
	if "Tilemap" in body.name and not is_on_floor():
		on_wall = false
