extends Control

signal exit_game
signal start_game

var world_node = null

func initialize(world : Node):
	world_node = world
	self.connect("exit_game", world_node, "exit_game")
	self.connect("start_game", world_node, "start_game")

func _on_ExitButton_pressed():
	emit_signal("exit_game")

func _on_StartButton_pressed():
	emit_signal("start_game")
