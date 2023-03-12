extends Area2D

onready var global = get_node("/root/Global")

export var point_value = 2000

func _ready():
	$AnimationPlayer.play("default")

func _on_Banana_body_entered(body):
	if "Player" in body.name:
		var i = global.death_explosion.instance()
		i.position = position
		i.explosion_scale = 0.5
		get_parent().add_child(i)
		global.update_score(point_value)
		global.get_node("UI/GameUI").update_collectibles_obtained()
		$AnimationPlayer.play("collect")

func die():
	queue_free()
