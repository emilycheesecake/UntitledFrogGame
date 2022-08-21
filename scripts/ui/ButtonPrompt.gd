extends Node2D

onready var global = get_node("/root/Global")

export var prompt_type:String

# Change button prompt depending on input type
func _ready():
	change_type(prompt_type)

func change_type(type):
	var anim_prefix = global.input_type + "_"
	match type:
		"interact":
			$AnimatedSprite.animation = anim_prefix + "interact"
		"attack":
			$AnimatedSprite.animation = anim_prefix + "attack"
		"jump":
			$AnimatedSprite.animation = anim_prefix + "jump"
		"walljump":
			$AnimatedSprite.animation = anim_prefix + "jump"
		"save":
			$AnimatedSprite.animation = anim_prefix + "interact"