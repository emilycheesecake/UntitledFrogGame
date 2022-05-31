extends KinematicBody2D

onready var global = get_node("/root/Global")

var velocity = Vector2()
var stunned = false

export var flip = false
export var gravity = 200.0
export var speed = 20
export var state = "idle"
export var knockback = 40
export var point_value = 450


func _ready():
	$Sprite.material.set_shader_param("active", false)
	$HitTimer.stop()

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

func _on_Trigger_area_entered(area):
	if "EnemyWall" in area.name:
		$Sprite.flip_h = !$Sprite.flip_h

func hit(knockback):
	state = "hit"
	velocity.x = 0
	$HitTimer.start()
	position.y -= knockback.y
	position.x += knockback.x
	$AnimationTree.set("parameters/isHit/active", true)

func die():
	var i = global.death_explosion.instance()
	i.position = position
	get_parent().add_child(i)
	global.update_score(point_value)
	queue_free()


func _on_HitTimer_timeout():
	die()


func _on_Trigger_body_entered(body):
	if "Player" in body.name:
		body.hurt()
