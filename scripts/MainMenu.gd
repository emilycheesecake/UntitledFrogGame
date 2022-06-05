extends CanvasLayer

onready var global = get_node("/root/Global")


func _ready():
	$CRTShader.visible = global.crt_shader
	$CenterContainer/VBoxContainer/Settings/Scanline/CheckButton.pressed = global.crt_shader
	$CenterContainer/VBoxContainer/Settings/Music/CheckButton.pressed = global.music

func _process(delta):
	pass

func _on_StartButton_pressed():
	global.change_scene(3)
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
	
