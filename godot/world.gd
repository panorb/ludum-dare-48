extends Node

onready var main_menu_scene = preload("res://Menus/MainMenu.tscn")
onready var player_shell_scene = preload("res://Shell/PlayerShell.tscn")

var current_scene_node = null

func _ready():
	default_view()

func exit_game():
	get_tree().quit()

func start_game():
	change_scene(player_shell_scene)
	
func change_scene(new_scene):
	SoundController.stop_music()
	if current_scene_node:	
		current_scene_node.queue_free()
	var scene_instance = new_scene.instance()
	scene_instance.initialize(self)
	current_scene_node = scene_instance
	self.add_child(scene_instance)

func default_view():
	change_scene(main_menu_scene)


