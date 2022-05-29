extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationTree.set("parameters/explode/active", true)
	$Sprite.modulate = Color(0, 0, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DeathTimer_timeout():
	queue_free()
