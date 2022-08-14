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
export var exit_spawn = Vector2.ZERO


func _ready():
	$Label.text = interact_text
	
	match(door_color):
		"blue":
			$Door.texture = blue_door_tex
		"purple":
			$Door.texture = purple_door_tex
			if not global.unlocked_grape:
				$Label.text = "Locked"
				$Banner.visible = false
				$Label.rect_position.y = $Banner.position.y - 4
		"green":
			$Door.texture = green_door_tex
			if not global.unlocked_melon:
				$Label.text = "Locked"
				$Banner.visible = false
				$Label.rect_position.y = $Banner.position.y - 4
		"black":
			$Door.texture = black_door_tex
			$Banner.visible = false
			# Move the door label down in the absence of banner
			$Label.rect_position.y = $Banner.position.y - 4
	
	match(banner_color):
		"blue":
			$Banner.texture = blue_banner_tex
		"purple":
			$Banner.texture = purple_banner_tex
		"green":
			$Banner.texture = green_banner_tex
			
	match(global.input_type):
		"keyboard":
			$ButtonPrompt.texture = global.keyboard_interact
		"xbox":
			$ButtonPrompt.texture = global.xbox_interact
		"ps":
			$ButtonPrompt.texture = global.ps_interact

func _input(event):
	if event.is_action_pressed("interact") and $Label.visible:
		if door_color == "black":
			global.exit_spawn = exit_spawn
		if door_color == "purple" and not global.unlocked_grape:
			return
		if door_color == "green" and not global.unlocked_melon:
			return
		global.change_scene(next_scene)

func _on_Area2D_body_entered(body):
	if "Player" in body.get_name():
		$Label.visible = true
		$ButtonPrompt.position.x = $Label.rect_position.x - 10
		$ButtonPrompt.position.y = $Label.rect_position.y + 6
		if $Label.text != "Locked":
			$ButtonPrompt.visible = true

func _on_Area2D_body_exited(body):
	if "Player" in body.get_name():
		$Label.visible = false
		$ButtonPrompt.visible = false
