extends Node


signal command_error(msg)
signal command_message(msg)
signal command_finished

var aliases : PoolStringArray = []
var command_name : String = ""
var command_description : String = ""

func send_message(text: String):
	emit_signal("command_message", text)

func print_description():
	return command_name + " - " + command_description
