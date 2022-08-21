extends "res://scripts/enemies/Enemy.gd"

var stunned = false
var velocity = Vector2.ZERO

export var flip = false
export var gravity = 200.0
export var speed = 20
export var rolling_speed = 40
export var max_health = 15
var dead = false
export var can_attack = true
var is_attacking = false


func _ready():
	# Set point value
	point_value = 450
	# Set health
	set_health(max_health)
	$Sprite.material.set_shader_param("active", false)

func _physics_process(delta):
	if not global.paused:
		if $AnimationTree.process_mode == AnimationTree.ANIMATION_PROCESS_MANUAL:
			$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_IDLE
	
		if not dead:
			if is_attacking:
				if position.x < global.player.position.x:
					velocity.x = rolling_speed
					$Sprite.flip_h = false
				if position.x > global.player.position.x:
					velocity.x = -rolling_speed
					$Sprite.flip_h = true
			else:
				velocity.x = speed if $Sprite.flip_h else -speed
			
			# Flip attack area
			if $Sprite.flip_h:
				$AttackArea.scale = Vector2(-1,1)
			else:
				$AttackArea.scale = Vector2(1,1)
		
		velocity.y += gravity * delta
	
		velocity = move_and_slide(velocity, Vector2(0, -1))
	else:
		$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_MANUAL

func _on_Hitbox_body_entered(body):
	if "Player" in body.name:
		body.hurt()
			
	if "Dude" in body.name:
		$Sprite.flip_h = !$Sprite.flip_h

func _on_Hitbox_area_entered(area):
	if "EnemyWall" in area.name:
		$Sprite.flip_h = !$Sprite.flip_h

func _on_AttackArea_body_entered(body):
	if "Player" in body.name and can_attack:
		$AnimationTree.set("parameters/isAttacking/active", true)
		is_attacking = true
		$AttackTimer.start()

func _on_AttackTimer_timeout():
	can_attack = true
	$AttackTimer.stop()

