extends "res://scripts/enemies/Enemy.gd"

var is_falling
var is_aiming
var can_attack = true
var player
var blast_player
var velocity = Vector2.ZERO
var initial_pos = Vector2.ZERO
var target = Vector2.ZERO
var returning = false

export var falling_speed = 60
export var move_speed = 30
export var idle_distance = 60
export var flipped_path = false

func _ready():
	initial_pos = position
	target = Vector2(position.x + idle_distance, position.y) if not flipped_path else Vector2(position.x - idle_distance, position.y)

func _physics_process(delta):
	if player != null and not is_falling:
		if can_attack:
			var r = randi() % 100 + 1
			if r % 3 == 0: # This makes a one in three chance i think? i'm high
				is_aiming = true
			else:
				can_attack = false
				$AttemptTimer.start()
		
		if is_aiming:
			if position.x < player.position.x:
				$MelonSprite.flip_h = true
				velocity.x = move_speed
			if position.x > player.position.x:
				$MelonSprite.flip_h = false
				velocity.x = -move_speed
			if abs(position.x - player.position.x) < 3:
				attack()
		else:
			if not returning:
				if position.x < target.x:
					velocity.x = move_speed
				if position.x > target.x:
					velocity.x = -move_speed
				if position.x == target.x:
					returning = true
					$MelonSprite.flip_h = false
			else:
				if position.x < initial_pos.x:
					velocity.x = move_speed
				if position.x > initial_pos.x:
					velocity.x = -move_speed
				if position.x == initial_pos.x:
					returning = false
					$MelonSprite.flip_h = true


	if is_falling:
		velocity.x = 0
		velocity.y = falling_speed

	velocity = move_and_slide(velocity)

	if is_falling and velocity.y < 40:
		explode()
		die()
func aim():
	is_aiming = true
	if abs(position.x - player.position.x) < 10:
		attack()

func attack():
	is_falling = true
	$AnimationPlayer.play("drop")
	$PropellerSprite.play("separate")
	$DeathTimer.start()

func explode():
	if blast_player != null:
		blast_player.hurt()

func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		player = null

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		player = body

func _on_AttemptTimer_timeout():
	can_attack = true
	$AttemptTimer.stop()

func _on_DeathTimer_timeout():
	die()
	explode()
	$DeathTimer.stop()

func _on_BlastZone_body_exited(body):
	if "Player" in body.name:
		blast_player = null

func _on_BlastZone_body_entered(body):
	if "Player" in body.name:
		blast_player = body
