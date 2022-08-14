extends CanvasLayer

onready var global = get_node("/root/Global")


func prepare():
	global.transition_in()
	global.change_scene(0)
	
func die():
	global.transition_in()
	queue_free()
