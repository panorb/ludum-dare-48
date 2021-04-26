extends "base-command.gd"

func _ready():
	aliases = ["exit", "quit"]
	command_description = "Closes the shell and returns to main menu"
	long_description = """Closes the shell and returns to main menu

exit

[b]Valid usage examples:[/b]
exit
"""
	

func execute(args):
	if args.size() >= 2:
		throw_error("Error: Too many arguments")
	else:
		exit()
	execution_finished()
