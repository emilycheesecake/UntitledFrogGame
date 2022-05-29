extends CanvasLayer

onready var global = get_node("/root/Global")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	global.change_scene(1)
	global.show_ui()
	queue_free()


func _on_QuitButton_pressed():
	get_tree().quit()
