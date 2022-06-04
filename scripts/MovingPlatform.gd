extends Node2D


export var move_distance = 50
export var speed = 10
export var vertical_movement = false

var target = Vector2.ZERO
var initial_pos = Vector2.ZERO
var moving_right = true
var is_moving = false


func _ready():
	initial_pos = position
	target = Vector2(position.x + move_distance, position.y)

func _physics_process(delta):
	if is_moving:
		if moving_right:
			if position.x < target.x:
				position.x += speed * delta
			else:
				moving_right = false
				is_moving = false
				$StopTimer.start()
		else:
			if position.x > initial_pos.x:
				position.x -= speed * delta
			else:
				moving_right = true
				is_moving = false
				$StopTimer.start()


func _on_StopTimer_timeout():
	is_moving = true
	$StopTimer.stop()
