extends "file.gd"


signal error(text, time, channel)
signal message(text, time, channel)
signal finished
signal clear_channel(channel)


func execute():
	execution_finished()


func send_message(msg: String, display_time := -1, channel := "main"):
	emit_signal("message", msg, display_time, channel)


func throw_error(msg: String, display_time := -1, channel := "main"):
	emit_signal("error", msg, display_time, channel)


func execution_finished():
	emit_signal("finished")


func clear_channel(channel: String):
	emit_signal("clear_channel", channel)
