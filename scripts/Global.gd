extends Node2D

var in_game = false
var paused = false
var current_level = 1
var player

export(PackedScene) var main_menu
export(PackedScene) var pause_menu
export(PackedScene) var main_level
export(PackedScene) var selection_level
export(PackedScene) var blue_land
export(PackedScene) var purple_land
export(PackedScene) var green_land
export(PackedScene) var player_scene


func _ready():
	update_score(69420)
	update_life(69)

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

func clear_scene():
	for n in $Game.get_children():
		$Game.remove_child(n)
		n.queue_free()

func change_scene(scene):
	transition_out()
	yield($UI/CircleTransition/AnimationPlayer, "animation_finished")
	
	if !get_node_or_null("/root/Global/Player"):
		start_game()
	
	clear_scene()
	match(scene):
		0: # Main Menu
			for c in $UI/GameUI.get_children():
				c.visible = false
			var i = main_menu.instance()
			$Game.add_child(i)
		1: # Main Level
			var i = main_level.instance()
			player.position = i.get_node("SpawnLocation").position
			$Game.add_child(i)
		2: # Selection Room
			var i = selection_level.instance()
			player.position = i.get_node("SpawnLocation").position
			$Game.add_child(i)
		3: # Blue Land
			pass
		4: #Purple Land
			pass
		5: #Green Land
			var i = green_land.instance()
			player.position = i.get_node("SpawnLocation").position
			$Game.add_child(i)
			
	# Run
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
	$UI/GameUI/ScoreLabel.text = "%08d" % [score]
	
func update_life(life):
	$UI/GameUI/LifeLabel.text = "%02d" % [life]
	
func transition_in():
	$UI/CircleTransition.transition_in()
	
func transition_out():
	$UI/CircleTransition.transition_out()
	
