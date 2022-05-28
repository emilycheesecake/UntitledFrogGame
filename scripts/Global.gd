extends Node2D

var in_game = false
var current_level = 1

export(PackedScene) var main_menu
export(PackedScene) var main_level
export(PackedScene) var selection_level

export(PackedScene) var player_scene
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = player_scene.instance()
	i.position = Vector2(200, 300)
	add_child(i)
	player = get_node("Player")

func _process(delta):
	if in_game:
		$UI/HealthBar.visible = false

func clear_scene():
	for n in $Game.get_children():
		$Game.remove_child(n)
		n.queue_free()

func change_scene(scene):
	clear_scene()
	match(scene):
		0:
			var i = main_menu.instance()
			$Game.add_child(i)
		1:
			var i = main_level.instance()
			player.position = i.get_node("SpawnLocation").position
			$Game.add_child(i)
		2:
			var i = selection_level.instance()
			player.position = i.get_node("SpawnLocation").position
			$Game.add_child(i)
