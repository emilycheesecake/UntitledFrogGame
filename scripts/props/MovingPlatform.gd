extends Node2D

onready var global = get_node("/root/Global")

export var move_distance = 50
export var speed = 10
export var vertical_movement = false

var target = Vector2.ZERO
var initial_pos = Vector2.ZERO
var moving_right = true
var moving_up = true
var is_moving = false
var velocity = Vector2.ZERO
var player = null
var player_indicator = null

func _ready():
	initial_pos = position
	if vertical_movement:
		target = Vector2(position.x, position.y - move_distance)
		$IndicatorArea/CollisionShape2D.shape.extents.y = (move_distance * 2)
	else:
		target = Vector2(position.x + move_distance, position.y)
		$IndicatorArea/CollisionShape2D.shape.extents.x = (move_distance * 2)

func _physics_process(delta):
	velocity = Vector2.ZERO
	if is_moving:
		if vertical_movement:
			if player_indicator != null:
				if player_indicator.position.y - position.y > 120:
					global.update_indicator("up", true)
				else:
					global.update_indicator("up", false)
				if player_indicator.position.y - position.y < -120:
					global.update_indicator("down", true)
				else:
					global.update_indicator("down", false)
				if abs(player_indicator.position.x - position.x) > 150:
					global.update_indicator("up", false)
					global.update_indicator("down", false)
			else:
				global.update_indicator("up", false)
				global.update_indicator("down", false)

			if moving_up:
				if position.y > target.y:
					velocity.y -= speed
				else:
					moving_up = false
					is_moving = false
					$StopTimer.start()
			else:
				if position.y < initial_pos.y:
					velocity.y += speed
				else:
					moving_up = true
					is_moving = false
					$StopTimer.start()
			position += velocity * delta	
		else:
			if player_indicator != null:
				if player_indicator.position.x - position.x > 200:
					global.update_indicator("left", true)
				else:
					global.update_indicator("left", false)
				if player_indicator.position.x - position.x < -120:
					global.update_indicator("right", true)
				else:
					global.update_indicator("right", false)
				if abs(player_indicator.position.y - position.y) > 50:
					global.update_indicator("left", false)
					global.update_indicator("right", false)
			else:
				global.update_indicator("left", false)
				global.update_indicator("right", false)

			if moving_right:
				if position.x < target.x:
					velocity.x += speed
				else:
					moving_right = false
					is_moving = false
					$StopTimer.start()
			else:
				if position.x > initial_pos.x:
					velocity.x -= speed
				else:
					moving_right = true
					is_moving = false
					$StopTimer.start()
			position += velocity * delta
		if player != null:
			player.position += velocity * delta

	


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		player = body

func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		player = null


func _on_StopTimer_timeout():
	is_moving = true
	$StopTimer.stop()

func _on_IndicatorArea_body_entered(body):
	if "Player" in body.name:
		player_indicator = body


func _on_IndicatorArea_body_exited(body):
	if "Player" in body.name:
		player_indicator = null
