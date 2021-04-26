extends "base-command.gd"

func _ready():
	aliases = ["unlock"]
	command_description = "unlocks files and folders if provided the correct password"

func execute(_args):
	send_message("Please input password: ")
	allow_input(true)

func input(input):
	print(input)
	allow_input(false)
	execution_finished()
