extends "res://scripts/Enemy.gd"

var velocity = Vector2()
var stunned = false

export var flip = false
export var gravity = 200.0
export var speed = 20
export var state = "idle"
export var knockback = 40


func _ready():
	# Set point value
	point_value = 450
	$Sprite.material.set_shader_param("active", false)

func _physics_process(delta):
	if not global.paused:
		if $AnimationTree.process_mode == AnimationTree.ANIMATION_PROCESS_MANUAL:
			$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_IDLE
	
		if not stunned:
			if state == "idle":
				velocity.x = speed if $Sprite.flip_h else -speed
		
		velocity.y += gravity * delta
	
		velocity = move_and_slide(velocity, Vector2(0, -1))
	else:
		$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_MANUAL

func hit(knockback):
	state = "hit"
	velocity.x = 0
	position.y -= knockback.y
	position.x += knockback.x
	$AnimationTree.set("parameters/isHit/active", true)

func _on_Hitbox_body_entered(body):
	if "Player" in body.name:
		print("hurt player")
		body.hurt()

func _on_Hitbox_area_entered(area):
	if "EnemyWall" in area.name:
		$Sprite.flip_h = !$Sprite.flip_h
