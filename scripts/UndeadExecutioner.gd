extends KinematicBody2D


var initial_position
var player
var velocity = Vector2.ZERO

export var speed = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = position

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player != null:
		if position.x < player.position.x:
			velocity.x += speed
			$Sprite.flip_h = false
		if position.x > player.position.x:
			velocity.x -= speed
			$Sprite.flip_h = true
	else:
		if position.x < initial_position.x:
			velocity.x += speed
			$Sprite.flip_h = false
		if position.x > initial_position.x:
			velocity.x -= speed
			$Sprite.flip_h = true
	
	position += velocity * delta

func _on_SeekRange_body_entered(body):
	if "Player" in body.name:
		player = body


func _on_SeekRange_body_exited(body):
	if "Player" in body.name:
		player = null
