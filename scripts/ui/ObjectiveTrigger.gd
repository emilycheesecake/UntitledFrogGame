extends Area2D


func _on_ObjectiveTrigger_body_entered(body):
	if "Player" in body.name:
		$Objective.visible = true


func _on_ObjectiveTrigger_body_exited(body):
	if "Player" in body.name:
		$Objective.visible = false
