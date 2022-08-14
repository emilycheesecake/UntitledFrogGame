extends KinematicBody2D

onready var global = get_node("/root/Global")

var point_value = 100
var health = 15
var health_pickup = preload("res://scenes/props/HealthPowerUp.tscn")
var explosion_scale = 1.0
var boss = false

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

func set_health(max_health):
	health = max_health

func damage(amount):
	if health - amount <= 0:
		health = 0
		death_trigger()
	else:
		health -= amount
	$AnimationTree.set("parameters/isHit/active", true)
	if boss:
		global.update_boss_health(health)

func death_trigger():
	$AnimationTree.set("parameters/isDead/current", 1)

func die():
	var i = global.death_explosion.instance()
	i.position = position
	i.scale = Vector2(explosion_scale, explosion_scale)
	get_parent().add_child(i)
	global.update_score(point_value)
	try_powerup()
	queue_free()
