extends "base-command.gd"

func _ready():
	aliases = ["help"]
	command_name = "help"
	command_description = "show a brief description of a command"

func execute(args):
	if args.size() == 1:
		for child in get_parent().get_children():
			send_message(child.print_description())
	elif args.size() == 2:
		for child in get_parent().get_children():
			if args[1] in child.aliases:
				if child.command_name == "help":
					emit_signal("command_error", "THERE IS NO ESCAPE")
				else:
					send_message(child.print_description())
				emit_signal("command_finished")
				return
		emit_signal("command_error", "Error: Unknown command")
	else:
		emit_signal("command_error", "Error: Too many arguments")
	
	emit_signal("command_finished")


