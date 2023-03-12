extends RigidBody2D

onready var global = get_node("/root/Global")

export var health_amount = 1
export var gravity = 100

var type = 0
var frame = 78
var pickup_sound = preload("res://assets/sounds/powerup.wav")


func _ready():
	# Randomly choose between given fruit sprites
	type = randi() % 5 + 1
	match(type):
		0: # Undefined
			pass
		1: # Apple
			frame = 38
		2: # Strawberry
			frame = 65
		3: # Grape
			frame = 43
		4: # Cherry
			frame = 52
	$Sprite.frame = frame

func _physics_process(delta):
	applied_force = Vector2(0, gravity)

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		if body.health < body.max_health: # Only pickup if player needs it
			body.update_health(health_amount)
		else:
			global.update_score(200)
		$AudioStreamPlayer.stream = pickup_sound
		$AudioStreamPlayer.play()
		$Sprite.visible = false
		yield($AudioStreamPlayer, "finished")
		queue_free()
