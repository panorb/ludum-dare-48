extends Node

var file_system : Node

signal error(text, time, channel)
signal message(text, time, channel)
signal finished
signal clear_channel(channel)
signal ssh_connect(adress)
signal allow_input(allow)
signal exit
signal trigger_behavior(script_name)

func update_file_system(fs : Node):
	file_system = fs 

func input(input: String):
	pass

func execute(_args):
	pass

func allow_input(allow: bool):
	emit_signal("allow_input", allow)

func send_message(msg: String, display_time := -1, channel := "main"):
	emit_signal("message", msg, display_time, channel)

func throw_error(msg: String, display_time := -1, channel := "main"):
	emit_signal("error", msg, display_time, channel)

func execution_finished():
	emit_signal("finished")

func clear_channel(channel: String):
	emit_signal("clear_channel", channel)

func ssh_connect(adress: Dictionary):
	emit_signal("ssh_connect", adress)

func exit():
	emit_signal("exit")

func call_behavior_script(script_name):
	emit_signal("trigger_behavior", script_name)
