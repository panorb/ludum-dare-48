extends "file.gd"

signal error(text, time, channel)
signal message(text, time, channel)
signal finished
signal clear_channel(channel)
signal allow_input(allow)


func execute():
	Helper.pause_node(self, false)
	set_process_unhandled_input(true)


func send_message(msg: String, display_time := -1, channel := "main"):
	emit_signal("message", msg, display_time, channel)


func throw_error(msg: String, display_time := -1, channel := "main"):
	emit_signal("error", msg, display_time, channel)


func execution_finished():
	Helper.pause_node(self, true)
	emit_signal("finished")


func clear_channel(channel: String):
	emit_signal("clear_channel", channel)

func allow_input(allow: bool):
	emit_signal("allow_input", allow)

func input(_input: String):
	pass
