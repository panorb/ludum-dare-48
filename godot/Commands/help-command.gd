extends "base-command.gd"


func _ready():
	aliases = ["help", "man", "manual", "?"]
	command_description = "Show a list of commands or information for a single command"

func execute(args):
	if args.size() == 1:
		send_message("""[warning]You can go forward and backward inside of the [accent]command history[/accent] with the [accent]up and down arrow keys[/accent].
To see usage information about a specific command use [accent]help [command][/accent][/warning]""")
		send_message("")
		for child in get_parent().get_children():
			send_message(child.print_description())
	elif args.size() == 2:
		for child in get_parent().get_children():
			if args[1] in child.aliases:
				if child.name in self.aliases:
					execution_finished()
					play_animation("scare")
				else:
					send_message(child.long_description)
					execution_finished()
				return
		throw_error("Error: Unknown command")
	else:
		throw_error("Error: Too many arguments")
	
	execution_finished()


