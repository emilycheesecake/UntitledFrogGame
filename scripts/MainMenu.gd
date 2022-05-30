extends CanvasLayer

onready var global = get_node("/root/Global")


func _ready():
	get_node("CRT Shader").visible = global.crt_shader
	$CenterContainer/VBoxContainer/Settings/Scanline/CheckButton.pressed = global.crt_shader

func _process(delta):
	global.crt_shader = $CenterContainer/VBoxContainer/Settings/Scanline/CheckButton.pressed
	get_node("CRT Shader").visible = global.crt_shader

func _on_StartButton_pressed():
	global.change_scene(1)
	yield(global.get_node("UI/CircleTransition/AnimationPlayer"), "animation_finished")
	queue_free()

func _on_QuitButton_pressed():
	global.crt_shader = !global.crt_shader
	get_node("CRT Shader").visible = global.crt_shader


func _on_SettingsButton_pressed():
	$CenterContainer/VBoxContainer/Main.visible = false
	$CenterContainer/VBoxContainer/Settings.visible = true


func _on_SettingsBackButton_pressed():
	$CenterContainer/VBoxContainer/Settings.visible = false
	$CenterContainer/VBoxContainer/Main.visible = true
