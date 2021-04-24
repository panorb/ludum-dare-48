extends Node


signal command_error(msg)
signal command_message(msg)
signal command_finished


func send_message(text: String):
	emit_signal("command_message", text)
