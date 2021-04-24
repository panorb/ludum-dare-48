extends Node

signal command_error(msg)
signal command_message(msg)
signal command_finished

var aliases : PoolStringArray = ["NULL"]
var command_description : String = ""

func send_message(text: String):
	emit_signal("command_message", text)

func print_description():
	return aliases[0] + " - " + command_description

func throw_error(message: String):
	emit_signal("command_error", message)

func execution_finished():
	emit_signal("command_finished")
