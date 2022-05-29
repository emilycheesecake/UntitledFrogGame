extends KinematicBody2D

var velocity = Vector2.ZERO
var flip = false
var is_jumping = false
var can_jump = true
var can_attack = true
var jump_strength = 0.0
var start_position = Vector2(50, -50)
export var can_move = true
export var is_dead = false

export var speed = 50
export var gravity = 200.0
export var jump_height = 200
export var death_height = 64
export var health = 6
var max_health = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	position = start_position

func _input(event):
	if event.is_action_released("jump"):
		jump()
		$JumpMeter.visible = false
		jump_strength = 0.0
		
	if event.is_action_pressed("attack"):
		attack()

func _physics_process(delta):
	if not is_dead:
		velocity.y += delta * gravity
	
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
		
			if is_on_floor():
				$AnimationTree.set("parameters/isWalking/current", 0)
	
		if Input.is_action_pressed("jump"):
			charge_jump(delta)
	
	if is_jumping and is_on_floor():
		is_jumping = false
		
	if is_jumping and not is_on_floor():
		$Sprite.frame = 17
		
	if position.y > death_height and not is_dead:
		die()
		
	
	get_node("/root/Global/UI/HealthBar").value = health
		
	velocity = move_and_slide(velocity, Vector2(0, -1))

func charge_jump(delta):
	if !is_jumping and jump_strength < jump_height:
		velocity.x = 0
		jump_strength += delta * 200
		$AnimationTree.set("parameters/isWalking/current", 0)    
		$JumpMeter.visible = true
		$JumpMeter.value = round(jump_strength / 40)
		print("Jump Strength: " + str(jump_strength))
	if jump_strength >= jump_height:
		jump()

func jump():
	if !is_jumping and can_jump:
		velocity.y = -jump_strength
		is_jumping = true
		can_jump = false
		$AnimationTree.set("parameters/isJumping/active", true)
		jump_strength = 0.0
		$JumpTimer.start()

func attack():
	$AnimationTree.set("parameters/isAttacking/active", true)
	can_move = false
	can_attack = false
	$AttackTimer.start()
	
func die():
	is_dead = true
	velocity = Vector2.ZERO
	position.y = death_height + 1
	$AnimationTree.set("parameters/isDead/active", true)
	$DeathTimer.start()

func _on_JumpTimer_timeout():
	can_jump = true
	$JumpTimer.stop()

func _on_AttackTimer_timeout():
	can_attack = true
	$AttackTimer.stop()

func _on_DeathTimer_timeout():
	position = start_position
	is_dead = false
	$AnimationTree.set("parameters/isDead/active", false)
	$Sprite.position.y = 0
	$DeathTimer.stop()
