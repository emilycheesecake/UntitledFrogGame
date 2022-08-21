extends Area2D

onready var global = get_node("/root/Global")

var player
var can_save = true

func _input(event):
	if event.is_action_pressed("interact") and player != null and can_save:
		global.save_game()
		$SavePrompt.visible = false
		can_save = false
		$Timer.start()

func _on_Checkpoint_body_entered(body):
	if "Player" in body.name:
		player = body
		if can_save:
			$SavePrompt.visible = true

func _on_Checkpoint_body_exited(body):
	if "Player" in body.name:
		player = null
		$SavePrompt.visible = false

func _on_Timer_timeout():
	can_save = true
	$Timer.stop()