extends "base-command.gd"


func _ready():
	aliases = ["help", "man", "manual", "?"]
	command_description = "Show a list of commands or information for a single command"

func execute(args):
	if args.size() == 1:
		for child in get_parent().get_children():
			send_message(child.print_description())
		send_message("")
		send_message("[accent]You can go forward and backward inside of the command history with the up and down arrow keys.[/accent]")
	elif args.size() == 2:
		for child in get_parent().get_children():
			if args[1] in child.aliases:
				if child.name in self.aliases:
					throw_error("THERE IS NO ESCAPE")
				else:
					send_message(child.long_description)
				execution_finished()
				return
		throw_error("Error: Unknown command")
	else:
		throw_error("Error: Too many arguments")
	
	execution_finished()


