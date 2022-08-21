extends CanvasLayer

onready var global = get_node("/root/Global")

export var initial_scene = 1


func _ready():
	if global.save_exists:
		$CenterContainer/VBoxContainer/Main/StartButton.text = "Load Game"
	else:
		$CenterContainer/VBoxContainer/Main/StartButton.text = "Start Game"

	$CRTShader.visible = global.crt_shader
	$CenterContainer/VBoxContainer/Settings/Scanline/CheckButton.pressed = global.crt_shader
	$CenterContainer/VBoxContainer/Settings/Music/CheckButton.pressed = global.music
	$CenterContainer/VBoxContainer/Settings/Input/Label.text = global.input_type

func _on_StartButton_pressed():
	var save = File.new()
	if save.file_exists("user://froggy.save"):
		global.spawn_player()
		global.load_game()
	else:
		global.change_scene(initial_scene)

	yield(global.get_node("UI/CircleTransition/AnimationPlayer"), "animation_finished")
	queue_free()

func _on_SettingsButton_pressed():
	$CenterContainer/VBoxContainer/Main.visible = false
	$CenterContainer/VBoxContainer/Settings.visible = true


func _on_SettingsBackButton_pressed():
	$CenterContainer/VBoxContainer/Settings.visible = false
	$CenterContainer/VBoxContainer/Main.visible = true

func _on_scanline_toggled(button_pressed):
	$CRTShader.visible = button_pressed
	global.crt_shader = button_pressed
	global.apply_settings()

func _on_music_toggled(button_pressed):
	global.music = button_pressed
	global.apply_settings()

func _on_DeleteButton_pressed():
	global.delete_save()


func _on_InputButton_pressed():
	match global.input_type:
		"keyboard":
			global.input_type = "xbox"
		"xbox":
			global.input_type = "ps"
		"ps":
			global.input_type = "keyboard"
	$CenterContainer/VBoxContainer/Settings/Input/Label.text = global.input_type
