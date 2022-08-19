extends Area2D


var player

export var tutorial_text = "Default Control Tutorial Text - change me!"
export var tutorial_type = "default"

func _ready():
	$Label.text = tutorial_text

func _input(event):
	if player != null:
		match(tutorial_type):
			"default":
				pass
			"jump":
				if event.is_action_pressed("jump"):
					$Timer.start()
			"attack":
				if event.is_action_pressed("attack"):
					$Timer.start()
			"walljump":
				if not player.can_wall_jump:
					$Timer.start()

func _on_Timer_timeout():
	queue_free()

func _on_ControlTutorial_body_entered(body):
	if "Player" in body.name:
		player = body
