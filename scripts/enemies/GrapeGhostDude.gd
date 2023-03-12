extends "res://scripts/enemies/Enemy.gd"

var velocity = Vector2.ZERO
var can_shoot = true

export var dead = false
export var max_health = 30
export(PackedScene) var grape_bullet;

func _ready():
	# Set point value
	point_value = 350
	# Set health
	set_health(max_health)

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if "Player" in body.name and not dead:
			# Depending on where the player is in relation
			# Choose different animation so dude is always "facing" player
			if position.x > body.position.x + 10:
				$AnimationTree.set("parameters/state/current", 0)
				$Sprite.flip_h = false
			elif position.x < body.position.x - 10:
				$AnimationTree.set("parameters/state/current", 0)
				$Sprite.flip_h = true
			else:
				$AnimationTree.set("parameters/state/current", 1)
			shoot(body.position)

func shoot(target):
	if can_shoot:
		$Sprite/Smoke.visible = true
		$AnimationTree.set("parameters/shooting/active", true)
		can_shoot = false
		var i = grape_bullet.instance()
		i.target = target
		i.position = position
		get_tree().get_root().get_node("Game").add_child(i)
		$CooldownTimer.start()

func hide_smoke():
	$Sprite/Smoke.visible = false

func _on_CooldownTimer_timeout():
	can_shoot = true
