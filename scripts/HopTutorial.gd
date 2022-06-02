extends Label


func _input(event):
	if event.is_action_pressed("jump"):
		$Timer.start()


func _on_Timer_timeout():
	queue_free()
