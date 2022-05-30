extends Node2D

var in_game = false
var paused = false
var crt_shader = true
var current_level = 1
var player
var exit_spawn = Vector2.ZERO

export(PackedScene) var main_menu
export(PackedScene) var pause_menu
export(PackedScene) var main_level
export(PackedScene) var selection_level
export(PackedScene) var blue_land
export(PackedScene) var purple_land
export(PackedScene) var green_land
export(PackedScene) var player_scene
export(PackedScene) var death_explosion


func _ready():
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		if paused:
			$UI/PauseMenu.queue_free()
		else:
			var i = pause_menu.instance()
			$UI.add_child_below_node($UI/GameUI, i)
		paused = !paused

func _process(delta):
	pass

func apply_settings():
	if get_node("UI/CRT Shader").visible != crt_shader:
		get_node("UI/CRT Shader").visible = crt_shader

func clear_scene():
	for n in $Game.get_children():
		$Game.remove_child(n)
		n.queue_free()

func change_scene(scene):
	transition_out()
	yield($UI/CircleTransition/AnimationPlayer, "animation_finished")
	
	# Spawn the player in if it has not
	if !get_node_or_null("/root/Global/Player"):
		start_game()
		
	clear_scene()
	var i # The new level instance
	match(scene):
		1: # Main Level
			i = main_level.instance()
		2: # Selection Room
			i = selection_level.instance()
		3: # Blue Land
			i = blue_land.instance()
		4: #Purple Land
			i = purple_land.instance()
		5: #Green Land
			i = green_land.instance()
	
	# Changing player position based on type of spawn
	if exit_spawn != Vector2.ZERO:
		player.position = exit_spawn
		exit_spawn = Vector2.ZERO
	else:
		player.position = i.get_node("SpawnLocation").position
	
	# Updating camera bounds
	if i.get_node_or_null("CameraCeiling"):
		player.get_node("Camera2D").limit_top = i.get_node("CameraCeiling").position.y
	
	# Adding new level scene
	$Game.add_child(i)
	transition_in()

func start_game():
	# Instancing the player and adding as child of Global
	var i = player_scene.instance()
	i.position = i.start_position
	add_child(i)
	player = get_node("/root/Global/Player")
	show_ui()

func show_ui():
	$UI/GameUI.visible = true
	
func hide_ui():
	$UI/GameUI.visible = false

func update_health(health):
	$UI/GameUI/HealthBar.value = health

func update_score(score):
	player.score += score
	$UI/GameUI/ScoreLabel.text = "%08d" % [player.score]
	
func update_life(life):
	$UI/GameUI/LifeLabel.text = "%02d" % [life]
	
func transition_in():
	$UI/CircleTransition.transition_in()
	
func transition_out():
	$UI/CircleTransition.transition_out()
