extends "base-command.gd"

func _ready():
	aliases = ["clear"]
	command_description = "Clears the console log"
	long_description = """Clears the console log

clear

[b]Valid usage examples:[/b]
clear
"""

func execute(_args):
	clear_channel("*")
	execution_finished()
