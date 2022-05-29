extends Node2D

onready var global = get_node("/root/Global")

var blue_door_tex = preload("res://assets/doors/bluedoor.png")
var purple_door_tex = preload("res://assets/doors/purpledoor.png")
var green_door_tex = preload("res://assets/doors/greendoor.png")
var black_door_tex = preload("res://assets/doors/blackdoor.png")

var blue_banner_tex = preload("res://assets/doors/bluebanner.png")
var purple_banner_tex = preload("res://assets/doors/purplebanner.png")
var green_banner_tex = preload("res://assets/doors/greenbanner.png")

export var door_color = "blue"
export var banner_color = "blue"
export var interact_text = "Exit"
export var next_scene = 0


func _ready():
	match(door_color):
		"blue":
			$Door.texture = blue_door_tex
		"purple":
			$Door.texture = purple_door_tex
		"green":
			$Door.texture = green_door_tex
		"black":
			$Door.texture = black_door_tex
			$Banner.visible = false
	
	match(banner_color):
		"blue":
			$Banner.texture = blue_banner_tex
		"purple":
			$Banner.texture = purple_banner_tex
		"green":
			$Banner.texture = green_banner_tex

func _input(event):
	if event.is_action_pressed("interact") and $Label.visible:
		global.change_scene(next_scene)

func _on_Area2D_body_entered(body):
	if "Player" in body.get_name():
		$Label.visible = true

func _on_Area2D_body_exited(body):
	if "Player" in body.get_name():
		$Label.visible = false
