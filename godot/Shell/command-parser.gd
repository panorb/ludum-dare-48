extends Node

signal error_occurred(msg, time, channel)
signal message_sent(msg, time, channel)
signal clear_channel(channel)
signal finished_execution
signal ssh_connect(adress)
signal allow_input(allow)
signal exit_shell
signal trigger_behavior(script_name)
signal play_animation(animation_name)

var _command : Node = null

func _ready():
	for child in get_children():
		child.connect("error", self, "_on_Command_error")
		child.connect("message", self, "_on_Command_message")
		child.connect("finished", self, "_on_Command_finished")
		child.connect("clear_channel", self, "_on_Command_clear_channel")
		child.connect("ssh_connect", self, "_on_Command_ssh_connect")
		child.connect("allow_input", self, "_on_Command_allow_input")
		child.connect("exit", self, "_on_Command_exit")
		child.connect("trigger_behavior", self, "_on_Command_trigger_behavior")
		child.connect("play_animation", self, "_on_Command_play_animation")

func input(input : String):
	if _command:
		_command.input(input)
	else:
		_execute(input)

func is_executing():
	return _command != null	

func _execute(cmd : String):
	var regex = RegEx.new()
	regex.compile("(\"[^\"]*\"|[^\\s\"]+)")
	
	var args = []
	for param in regex.search_all(cmd):
		var string = param.get_string().lstrip("\"").rstrip("\"")
		args.append(string)
	
	for child in get_children():
		if args[0] in child.aliases:
			emit_signal("allow_input", false)
			_command = child
			child.execute(args)
			return
	
	emit_signal("error_occurred", "Unknown command")
	emit_signal("finished_execution")

func update_file_system(fs: Node):
	for child in get_children():
		child.update_file_system(fs)

func finish_command():
	_command = null
	emit_signal("finished_execution")

func _on_Command_error(msg: String, display_time : float, channel : String):
	emit_signal("error_occurred", msg, display_time, channel)
	
func _on_Command_message(msg: String, display_time : float, channel : String):
	emit_signal("message_sent", msg, display_time, channel)

func _on_Command_finished():
	get_tree().create_timer(0.4).connect("timeout", self, "finish_command")

func _on_Command_clear_channel(channel: String):
	emit_signal("clear_channel", channel)

func _on_Command_ssh_connect(adress):
	emit_signal("ssh_connect", adress)
	
func _on_Command_allow_input(allow):
	emit_signal("allow_input", allow)

func _on_Command_exit():
	emit_signal("exit_shell")

func _on_Command_trigger_behavior(script_name):
	emit_signal("trigger_behavior", script_name)

func _on_Command_play_animation(animation_name):
	emit_signal("play_animation", animation_name)
