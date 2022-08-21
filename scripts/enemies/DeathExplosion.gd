extends Node2D

var death_sound = preload("res://assets/sounds/tinyexplode.wav")
var explosion_scale = 1.0

func _ready():
	scale = Vector2(explosion_scale, explosion_scale)
	$AudioStreamPlayer.stream = death_sound
	$AudioStreamPlayer.play()
	$AnimatedSprite.play("default")

func _on_DeathTimer_timeout():
	queue_free()
