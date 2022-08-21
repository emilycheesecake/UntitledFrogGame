extends Control

var left = false
var right = false

func _ready():
	visible = false

func flash_left():
	visible = true
	$AnimationPlayer.play("left")

func flash_right():
	visible = true
	$AnimationPlayer.play("right")

func stop_flash():
	visible = false
	$AnimationPlayer.stop()

