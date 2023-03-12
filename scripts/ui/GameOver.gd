extends ColorRect

onready var global = get_node("/root/Global")


func reset():
	global.player.reset()
	# global.delete_save() # Hardcore mode lol
	global.change_scene(0)
	
func die():
	queue_free()
