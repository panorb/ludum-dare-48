extends "base-command.gd"

var aliases = ["help", "exit", "cd", "ls", "cat", "ssh", "probe"]

func execute(_args):
	send_message("Not implemented.")
	emit_signal("command_finished")
