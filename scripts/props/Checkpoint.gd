extends Area2D

onready var global = get_node("/root/Global")

var player

func _input(event):
	if event.is_action_pressed("interact") and player != null and visible:
		global.save_game()
		visible = false
		$Timer.start()

func _on_Checkpoint_body_entered(body):
	if "Player" in body.name:
		player = body
		$SavePrompt.visible = true

func _on_Checkpoint_body_exited(body):
	if "Player" in body.name:
		player = null
		$SavePrompt.visible = false

func _on_Timer_timeout():
	visible = true
	$Timer.stop()