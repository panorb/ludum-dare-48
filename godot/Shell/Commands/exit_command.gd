extends "base-command.gd"

signal close

func _ready():
	aliases = ["exit", "quit"]
	command_name = "exit"
	command_description = "close the shell"#

func execute(args):
	if args.size() >= 2:
		emit_signal("command_error", "Error: Too many arguments")#
	else:
		emit_signal("command_message", "Closing ...")
	emit_signal("command_finished")
