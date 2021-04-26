extends "base-command.gd"

func _ready():
	aliases = ["clear"]
	command_description = "Clears the console output"

func execute(_args):
	clear_channel("*")
	execution_finished()
