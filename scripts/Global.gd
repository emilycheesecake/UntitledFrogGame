extends Node2D

var in_game = false
var paused = false
var crt_shader = true
var music = false
var current_level = 1
var player
var exit_spawn = Vector2.ZERO
var music_position
var input_type = "keyboard"
var level_spawn = Vector2.ZERO

var unlocked_grape = false
var unlocked_melon = false

# Music
var main_menu_music = preload("res://assets/music/MainMenu.wav")
var level_one_music = preload("res://assets/music/LevelOne.ogg")
var selection_music = preload("res://assets/music/SelectionRoom.wav")
var blue_land_music = preload("res://assets/music/BlueLevel.mp3")
var grape_galaxy_music = preload("res://assets/music/GrapeGalaxy.mp3")

# Button Prompts
var keyboard_interact = preload("res://assets/prompts/keyboard/interact.png")
var xbox_interact = preload("res://assets/prompts/xbox/interact.png")
var ps_interact = preload("res://assets/prompts/ps/interact.png")

export(PackedScene) var main_menu
export(PackedScene) var pause_menu
export(PackedScene) var game_over_menu
export(PackedScene) var main_level
export(PackedScene) var selection_level
export(PackedScene) var blue_land
export(PackedScene) var purple_land
export(PackedScene) var green_land
export(PackedScene) var player_scene
export(PackedScene) var death_explosion


func _ready():
	randomize()

func _input(event):
	if event.is_action_pressed("pause"):
		if paused:
			if music: # Restart music if desired
				$AudioStreamPlayer.play(music_position)
			$UI/PauseMenu.queue_free()
		else:
			#Stop music when pausing
			music_position = $AudioStreamPlayer.get_playback_position()
			$AudioStreamPlayer.stop()
			var i = pause_menu.instance()
			$UI.add_child_below_node($UI/GameUI, i)
		paused = !paused

func _process(delta):
	pass

func apply_settings():
	if $UI/CRTShader.visible != crt_shader:
		$UI/CRTShader.visible = crt_shader
	if music:
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()

func clear_scene():
	for n in $Game.get_children():
		$Game.remove_child(n)
		n.queue_free()

func change_scene(scene):
	if scene != 0:
		transition_out()
		yield($UI/CircleTransition/AnimationPlayer, "animation_finished")
	
	# Spawn the player in if it has not
	if !get_node_or_null("/root/Global/Player"):
		spawn_player()
		
	clear_scene()
	var i # The new level instance
	match(scene):
		0: # Main Menu
			i = main_menu.instance()
			player.queue_free()
			hide_ui()
			$AudioStreamPlayer.stream = main_menu_music
		1: # Main Level
			i = main_level.instance()
			$AudioStreamPlayer.stream = level_one_music
		2: # Selection Room
			i = selection_level.instance()
			$AudioStreamPlayer.stream = selection_music
		3: # Blue Land
			i = blue_land.instance()
			$AudioStreamPlayer.stream = blue_land_music
		4: #Purple Land
			i = purple_land.instance()
			$AudioStreamPlayer.stream = grape_galaxy_music
		5: #Green Land
			i = green_land.instance()
			$AudioStreamPlayer.stream = null
	
	# Music
	if music:
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()
		
	# Changing player position based on type of spawn
	if exit_spawn != Vector2.ZERO:
		player.position = exit_spawn
		exit_spawn = Vector2.ZERO
	elif scene != 0: # Update player spawn location as long as it's not the main menu
		player.position = i.get_node("SpawnLocation").position
		level_spawn = i.get_node("SpawnLocation").position
	
	# Updating camera bounds
	if i.get_node_or_null("CameraCeiling"):
		player.get_node("Camera2D").limit_top = i.get_node("CameraCeiling").position.y
	else:
		player.get_node("Camera2D").limit_top = -10000000
		
	if i.get_node_or_null("CameraFloor"):
		# Needed to mess with the position of the CameraFloor to get desired effect for some reason?
		player.get_node("Camera2D").limit_bottom = i.get_node("CameraFloor").position.y + 50
	else:
		player.get_node("Camera2D").limit_bottom = 10000000
	
	current_level = scene
	# Adding new level scene
	$Game.add_child(i)
	transition_in()

func spawn_player():
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

func update_jump_strength(strength):
	$UI/GameUI/JumpMeter.value = strength

func transition_in():
	$UI/CircleTransition.transition_in()
	
func transition_out():
	$UI/CircleTransition.transition_out()

func game_over():
	var i = game_over_menu.instance()
	$UI.add_child_below_node($UI/GameUI, i)

func stop_music():
	$AudioStreamPlayer.stop()
	
func start_music():
	$AudioStreamPlayer.play()

func update_boss_health(health):
	$UI/GameUI/BossHealth.value = health

func set_boss_health_visibility(v):
	$UI/GameUI/BossHealth.visible = v
	$UI/GameUI/BossLabel.visible = v

func set_boss_name(name):
	$UI/GameUI/BossLabel.text = name