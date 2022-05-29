extends KinematicBody2D

onready var global = get_node("/root/Global")

var velocity = Vector2.ZERO
var is_jumping = false
var jump_strength = 0.0
var start_position = Vector2(50, -50)
var max_health = 6

export var can_move = true
export var is_dead = false
export var speed = 50
export var gravity = 200.0
export var jump_height = 200
export var death_height = 48
export var health = 6
export var lives = 69

func _ready():
	position = start_position

func _input(event):
	if not global.paused:
		# Jump when action is released
		if event.is_action_released("jump") and is_on_floor():
			jump()
			$JumpMeter.visible = false
		if event.is_action_pressed("attack"):
			attack()

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
				$AnimationTree.set("parameters/isWalking/current", 1)
			elif Input.is_action_pressed("move_left"):
				velocity.x = -speed
				$Sprite.flip_h = true
				$AnimationTree.set("parameters/isWalking/current", 1)
			else:
				velocity.x = 0
				# Change animation to idle if no horizontal movement and on ground
				if is_on_floor():
					$AnimationTree.set("parameters/isWalking/current", 0)
			
			if position.y > death_height:
				die()
				
			if is_jumping:
				if is_on_floor():
					is_jumping = false # Reset after player touches ground after jumping
				else:
					print("MANUAL")
					$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_MANUAL
					$Sprite.frame = 17
			elif is_on_floor():
				# Charge jump when held
				if Input.is_action_pressed("jump"):
					charge_jump(delta)
				$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_IDLE
			
			# Update health UI
			global.update_health(health)
			velocity = move_and_slide(velocity, Vector2(0, -1))
	else:
		# Change process mode to manual when game is paused
		$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_MANUAL

func charge_jump(delta):
	$AnimationTree.set("parameters/jumpPrep/current", 1)
	# Show and fill jump meter
	if jump_strength < jump_height:
		velocity.x /= 2
		jump_strength += delta * 200 # Speed that jump charges
		$AnimationTree.set("parameters/isWalking/current", 0)    
		$JumpMeter.visible = true
		$JumpMeter.value = round(jump_strength / 40)
	# Jump automatically when jump meter fills
	if jump_strength >= jump_height:
		jump()

func jump():
	if !is_jumping and !is_dead:
		velocity.y = -jump_strength
		is_jumping = true
		$AnimationTree.set("parameters/jumpPrep/current", 0)
		$AnimationTree.set("parameters/isJumping/active", true)
		jump_strength = 0.0
		$JumpMeter.visible = false

func attack():
	$AnimationTree.set("parameters/isAttacking/active", true)
	can_move = false
	$AttackTimer.start()
	
func die():
	is_jumping = false
	$JumpMeter.visible = false
	is_dead = true
	velocity = Vector2.ZERO
	position.y = death_height - 16
	$AnimationTree.set("parameters/isDead/active", true)
	
func death_reset():
	global.transition_out()
	position = start_position
	is_dead = false
	$AnimationTree.set("parameters/isDead/active", false)
	$Sprite.position.y = 0
	# Update lives
	lives -= 1
	global.update_life(lives)
	global.transition_in()

