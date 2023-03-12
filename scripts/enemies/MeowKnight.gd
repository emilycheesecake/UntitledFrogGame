extends "res://scripts/enemies/Enemy.gd"

var initial_position
var player = null
var velocity = Vector2.ZERO
export var is_dead = false
export var is_hit = false

export var speed = 20
export var gravity = 200.0
export var max_health = 100
export var boss_name = "ssssssss"

# Called when the node enters the scene tree for the first time.
func _ready():
	boss = true
	# Set point value
	point_value = 1500
	# Bigger boom for bigger boss
	explosion_scale = 2.0
	global.set_boss_name(boss_name)
	initial_position = position
	# Set health
	set_health(max_health)

func _physics_process(delta):
	if not global.paused:
		if $AnimationTree.process_mode == AnimationTree.ANIMATION_PROCESS_MANUAL:
			$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_IDLE

		# Gravity
		velocity.y += delta * gravity

		if not is_hit:
			if player != null:
				global.set_boss_health_visibility(true)
				$AnimationTree.set("parameters/isMoving/current", 1)
				if position.x < player.position.x:
					velocity.x = speed
					$Sprite.flip_h = false
				if position.x > player.position.x:
					velocity.x = -speed
					$Sprite.flip_h = true
			else:
				global.set_boss_health_visibility(false)
				$AnimationTree.set("parameters/isMoving/current", 0)
				if position.x < initial_position.x:
					velocity.x = speed
					$Sprite.flip_h = false
				if position.x > initial_position.x:
					velocity.x = -speed
					$Sprite.flip_h = true
		else:
			velocity.x = 0 # stop moving horizontally when hit
	
		if not is_dead:
			velocity = move_and_slide(velocity, Vector2(0, -1))
	else:
		$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_MANUAL



func _on_SightRange_body_entered(body):
	if "Player" in body.name:
		player = body


func _on_ChaseRange_body_exited(body):
	if "Player" in body.name:
		player = null

func hit(damage):
	if health - damage <= 0:
		health = 0
		is_dead = true
		$AnimationTree.set("parameters/isDead/current", 1)
	else:
		health -= damage
	
	global.update_boss_health(health)
	$AnimationTree.set("parameters/isHit/active", true)

func kill():
	global.set_boss_health_visibility(false)
	global.update_boss_health(max_health)
	die()

func _on_Hitbox_body_entered(body):
	if "Player" in body.name:
		print("hurt player")
		body.hurt()
