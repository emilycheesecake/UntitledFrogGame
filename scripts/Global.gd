extends Node2D

onready var game_node = get_node("/root/Game")
onready var indicators = $UI/Indicators

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

var loaded = false
var save_exists = false

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
	var save = File.new()
	if save.file_exists("user://froggy.save"):
		save_exists = true
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

	if event.is_action_pressed("save"):
		save_game()
	if event.is_action_pressed("load"):
		load_game()

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
	for n in game_node.get_children():
		game_node.remove_child(n)
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
	match scene:
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
		_: #Default
			i = main_level.instance()
	
	# Music
	if music:
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()
		
	# Changing player position based on type of spawn
	if exit_spawn != Vector2.ZERO:
		player.position = exit_spawn
		exit_spawn = Vector2.ZERO
	elif scene != 0: # Update level spawn location as long as it's not the main menu
		level_spawn = i.get_node("SpawnLocation").position
		if not loaded: # Only use level spawn if not loading a save
			player.position = level_spawn
	
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
	game_node.add_child(i)
	transition_in()

	if loaded:
		loaded = false

func spawn_player():
	# Instancing the player and adding as child of Global
	var i = player_scene.instance()
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

func change_score(score):
	player.score = score
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

func save():
	var save_dict = {
		"current_level" : current_level,
		"crt_shader"    : crt_shader,
		"music"         : music,
		"input_type"    : input_type,
		"unlocked_grape": unlocked_grape,
		"unlocked_melon": unlocked_melon,
	}
	return save_dict

func save_player():
	var save_dict = {
		"pos_x"    : player.position.x,
		"pos_y"    : player.position.y,
		"score"    : player.score,
		"lives"    : player.lives,
		"health"   : player.health
	}
	return save_dict

func save_game():
	var save = File.new()
	save.open("user://froggy.save", File.WRITE)
	
	var node_data = save()
	var player_data = save_player()
	save.store_line(to_json(node_data))
	save.store_line(to_json(player_data))
	save.close()
	$UI/SaveNotification.notify()

func load_game():
	paused = true
	var loaded_player_position = Vector2.ZERO
	var save = File.new()
	if not save.file_exists("user://froggy.save"):
		return

	save.open("user://froggy.save", File.READ)
	var l = 1
	while save.get_position() < save.get_len():
		var node_data = parse_json(save.get_line())

		for i in node_data.keys():
			if l == 2:
				if i == "pos_x" or i == "pos_y":
					continue
				player.set(i, node_data[i])
			if l == 1:
				set(i, node_data[i])
		
		if l == 2:
			loaded_player_position = Vector2(node_data["pos_x"], node_data["pos_y"])

		l += 1
	save.close()
	loaded = true
	# Needed to cast current_level to an integer for change_scene
	# to work? Not sure why.
	change_scene(int(current_level))
	yield(get_tree().create_timer(1.0), "timeout")
	player.position = loaded_player_position
	change_score(player.score)
	update_health(player.health)
	update_life(player.lives)
	paused = false

func delete_save():
	var save = File.new()
	var dir = Directory.new()

	if save.file_exists("user://froggy.save"):
		dir.remove("user://froggy.save")
		print("Save Deleted.")
	else:
		print("No Save to Delete.")


