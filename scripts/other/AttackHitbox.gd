extends Area2D

var knockback = Vector2.ZERO
var player

func _ready():
	player = get_parent()

func _on_AttackHitbox_body_entered(body):
	if "Dude" in body.name:
		if player.position.x > body.position.x:
			knockback = Vector2(-body.knockback, body.knockback / 2)
		else:
			knockback = Vector2(body.knockback, body.knockback / 2)
		
		body.hit(knockback)
		queue_free()


func _on_Timer_timeout():
	queue_free()
