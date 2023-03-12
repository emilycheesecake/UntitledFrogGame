extends Node2D

var speed = 50
var target = Vector2.ZERO
var velocity = Vector2.ZERO


func _ready():
	velocity = target - position

func _physics_process(delta):
	position += velocity * delta

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		body.hurt()
		queue_free()
	elif not ("Dude" in body.name): # Keep bullet from despawning from hitting parent
		queue_free()

func _on_DeathTimer_timeout():
	queue_free()
