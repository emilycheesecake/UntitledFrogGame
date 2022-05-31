extends Node2D


var death_sound = preload("res://assets/sounds/tinyexplode.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.stream = death_sound
	$AudioStreamPlayer.play()
	$AnimatedSprite.play("default")

func _on_DeathTimer_timeout():
	queue_free()
