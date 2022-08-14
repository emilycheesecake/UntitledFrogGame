extends Area2D


func _on_DeathZone_body_entered(body):
	if "Player" in body.name:
		body.position.y = position.y
		body.die()
