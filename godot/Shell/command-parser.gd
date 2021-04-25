extends Node

signal error_occurred(msg, time, channel)
signal message_sent(msg, time, channel)
signal clear_channel(channel)
signal finished_execution

func _ready():
	for child in get_children():
		child.connect("command_error", self, "_on_Command_command_error")
		child.connect("command_message", self, "_on_Command_command_message")
		child.connect("command_finished", self, "_on_Command_command_finished")
		child.connect("command_clear_channel", self, "_on_Command_command_clear_channel")

func execute(cmd : String):
	var regex = RegEx.new()
	regex.compile("(\"[^\"]*\"|[^\\s\"]+)")
	
	var args = []
	for param in regex.search_all(cmd):
		var string = param.get_string().lstrip("\"").rstrip("\"")
		args.append(string)
	
	for child in get_children():
		if args[0] in child.aliases:
			child.execute(args)
			return
	
	emit_signal("error_occurred", "Unknown command")
	emit_signal("finished_execution")

func _on_Command_command_error(msg: String, display_time : float, channel : String):
	emit_signal("error_occurred", msg, display_time, channel)
	
func _on_Command_command_message(msg: String, display_time : float, channel : String):
	emit_signal("message_sent", msg, display_time, channel)

func _on_Command_command_finished():
	emit_signal("finished_execution")

func _on_Command_command_clear_channel(channel: String):
	emit_signal("clear_channel", channel)
