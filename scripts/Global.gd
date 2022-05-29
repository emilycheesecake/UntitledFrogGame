extends Node2D

var in_game = false
var paused = false
var current_level = 1

export(PackedScene) var main_menu
export(PackedScene) var pause_menu

export(PackedScene) var main_level
export(PackedScene) var selection_level

export(PackedScene) var player_scene
var player

func _ready():
	# Instancing the player and adding as child of Global
	var i = player_scene.instance()
	i.position = Vector2(0, -100)
	add_child(i)
	player = get_node("/root/Global/Player")
	
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

func show_ui():
	for c in $UI/GameUI.get_children():
		c.visible = true
	
func hide_ui():
	for c in $UI/GameUI.get_children():
		c.visible = false

func update_health(health):
	$UI/GameUI/HealthBar.value = health
	
func update_score(score):
	$UI/GameUI/ScoreLabel.text = "%08d" % [score]
	
func update_life(life):
	$UI/GameUI/LifeLabel.text = "%02d" % [life]
