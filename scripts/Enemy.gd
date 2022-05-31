extends KinematicBody2D

onready var global = get_node("/root/Global")

var point_value = 100
var health_pickup = preload("res://scenes/HealthPowerUp.tscn")

func _ready():
	pass

func try_powerup():
	var r = randi() % 100 + 1
	if r % 3 == 0: # This makes a one in three chance i think? i'm high
		drop_health_pickup()

func drop_health_pickup():
	var i = health_pickup.instance()
	i.position = position
	global.get_node("Game").add_child(i)

func die():
	var i = global.death_explosion.instance()
	i.position = position
	get_parent().add_child(i)
	global.update_score(point_value)
	try_powerup()
	queue_free()
