extends Node

signal command_error(text, time, channel)
signal command_message(text, time, channel)
signal command_finished
signal command_clear_channel(channel)

func send_message(msg: String, display_time := -1, channel := "main"):
	emit_signal("command_message", msg, display_time, channel)

func throw_error(msg: String, display_time := -1, channel := "main"):
	emit_signal("command_error", msg, display_time, channel)

func execution_finished():
	emit_signal("command_finished")

func clear_channel(channel: String):
	emit_signal("command_clear_channel", channel)
