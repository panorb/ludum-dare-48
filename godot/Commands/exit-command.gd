extends "base-command.gd"

func _ready():
	aliases = ["exit", "quit"]
	command_description = "Closes the shell"

func execute(args):
	if args.size() >= 2:
		throw_error("Error: Too many arguments")
	else:
		exit()
	execution_finished()
