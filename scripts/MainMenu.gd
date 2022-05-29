extends CanvasLayer

onready var global = get_node("/root/Global")


func _ready():
	pass

func _on_StartButton_pressed():
	global.change_scene(1)
	yield(global.get_node("UI/CircleTransition/AnimationPlayer"), "animation_finished")
	queue_free()

func _on_QuitButton_pressed():
	get_tree().quit()
