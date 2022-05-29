extends KinematicBody2D

onready var global = get_node("/root/Global")

var velocity = Vector2()
var stunned = false

export var flip = false
export var gravity = 200.0
export var speed = 20
export var state = "idle"
export var distance = 80


func _ready():
	$Sprite.material.set_shader_param("active", false)
	$HitTimer.stop()

func _physics_process(delta):
	if not global.paused and not stunned:
		if $AnimationTree.process_mode == AnimationTree.ANIMATION_PROCESS_MANUAL:
			$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_IDLE
	
		if state == "idle":
			velocity.x = speed if $Sprite.flip_h else -speed
		
		velocity.y += gravity * delta
	
		velocity = move_and_slide(velocity, Vector2(0, -1))
	else:
		$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_MANUAL

func _on_Trigger_area_entered(area):
	if "EnemyWall" in area.name:
		$Sprite.flip_h = !$Sprite.flip_h

func hit():
	$HitTimer.start()
	$AnimationTree.set("parameters/isHit/active", true)
	position.y -= 20
	position.x += 20
	stunned = true

func die():
	pass


func _on_HitTimer_timeout():
	stunned = false
	#$Sprite.material.set_shader_param("active", false)
	$HitTimer.stop()
