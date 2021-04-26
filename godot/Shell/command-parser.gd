extends Node

signal error_occurred(msg, time, channel)
signal message_sent(msg, time, channel)
signal clear_channel(channel)
signal finished_execution
signal ssh_connect(adress)
signal exit_shell

func _ready():
	for child in get_children():
		child.connect("error", self, "_on_Command_error")
		child.connect("message", self, "_on_Command_message")
		child.connect("finished", self, "_on_Command_finished")
		child.connect("clear_channel", self, "_on_Command_clear_channel")
		child.connect("ssh_connect", self, "_on_Command_ssh_connect")
		child.connect("exit", self, "_on_Command_exit")

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

func update_file_system(fs: Node):
	for child in get_children():
		child.file_system = fs

func _on_Command_error(msg: String, display_time : float, channel : String):
	emit_signal("error_occurred", msg, display_time, channel)
	
func _on_Command_message(msg: String, display_time : float, channel : String):
	emit_signal("message_sent", msg, display_time, channel)

func _on_Command_finished():
	emit_signal("finished_execution")

func _on_Command_clear_channel(channel: String):
	emit_signal("clear_channel", channel)

func _on_Command_ssh_connect(adress):
	emit_signal("ssh_connect", adress)

func _on_Command_exit():
	emit_signal("exit_shell")
