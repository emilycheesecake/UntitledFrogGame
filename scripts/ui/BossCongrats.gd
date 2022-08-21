extends Area2D

onready var global = get_node("/root/Global")

var boss
var exit_door

export var world = "grape"

func _ready():
	match world:
		"grape":
			$Label.text = "Grape Galaxy Unlocked!"
		"melon":
			$Label.text = "Melon Maze Unlocked!"

func _process(delta):
	if boss != null:
		if boss.is_dead:
			$Label.visible = true
			exit_door.visible = true
			if "grape" in world:
				global.unlocked_grape = true
			if "melon" in world:
				global.unlocked_melon = true
			global.save_game()
			boss = null

func _on_BossCongrats_body_entered(body):
	if "Meow" in body.name and boss == null:
		boss = body


func _on_BossCongrats_area_entered(area):
	if "Door" in area.name and exit_door == null:
		exit_door = area.get_owner()
		exit_door.visible = false
