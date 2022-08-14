extends ColorRect


func _ready():
	material.set_shader_param("circle_size", 1.05)

func transition_in():
	$AnimationPlayer.play("transition_in")
	
func transition_out():
	$AnimationPlayer.play("transition_out")
