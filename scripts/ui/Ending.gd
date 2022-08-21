extends Node2D

onready var global = get_node("/root/Global")

func _ready():
	$AnimationPlayer.play("credits")
	$CanvasLayer/CenterContainer/VBoxContainer/Score.text = "Score: " + str(global.player.score)
	global.player.queue_free()


func return_to_menu():
	global.transition_out()
	global.change_scene(0)
