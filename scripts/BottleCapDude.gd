extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var flip = false
export var gravity = 200.0
export var speed = 20
export var state = "idle"
export var distance = 80
var target = Vector2.ZERO
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	target = Vector2(position.x + distance, position.y)

func _physics_process(delta):
	if position.x >= target.x - 5 or position.x >= target.x + 5:
		change_direction()
	
	if state == "idle":
		pass
		
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	$Sprite.flip_h = flip

func change_direction():
	if flip:
		target = get_parent().get_node("TriggerB").position
		get_parent().get_node("TriggerA").monitoring = false
		flip = false
	else:
		target = get_parent().get_node("TriggerA").position
		flip = true


func _on_Area2D_area_entered(body):
	if "TriggerA" in body.name:
		print("TESTING")
		change_direction()
