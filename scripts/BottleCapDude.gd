extends KinematicBody2D

onready var global = get_node("/root/Global")

var target = Vector2.ZERO
var velocity = Vector2()

export var flip = false
export var gravity = 200.0
export var speed = 20
export var state = "idle"
export var distance = 80


func _ready():
	target = Vector2(position.x + distance, position.y)

func _physics_process(delta):
	if not global.paused:
		if $AnimationTree.process_mode == AnimationTree.ANIMATION_PROCESS_MANUAL:
			$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_IDLE
		
		if position.x >= target.x - 5 or position.x >= target.x + 5:
			change_direction()
	
		if state == "idle":
			pass
		
		velocity.y += gravity * delta
	
		velocity = move_and_slide(velocity, Vector2(0, -1))
		$Sprite.flip_h = flip
	else:
		$AnimationTree.process_mode = AnimationTree.ANIMATION_PROCESS_MANUAL

func change_direction():
	pass

func _on_Area2D_area_entered(body):
	if "TriggerA" in body.name:
		print("TESTING")
		change_direction()
