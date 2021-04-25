extends Node

signal error_occurred(msg)
signal message_sent(msg)
signal finished_execution

func _ready():
	for child in get_children():
		child.connect("command_error", self, "_on_Command_command_error")
		child.connect("command_message", self, "_on_Command_command_message")
		child.connect("command_finished", self, "_on_Command_command_finished")

func execute(cmd : String):
	var args = cmd.split(" ")
	
	for child in get_children():
		if args[0] in child.aliases:
			child.execute(args)
			return
	
	emit_signal("error_occurred", "Unknown command")
	emit_signal("finished_execution")

func _on_Command_command_error(msg : String):
	emit_signal("error_occurred", msg)
	
func _on_Command_command_message(msg: String):
	emit_signal("message_sent", msg)

func _on_Command_command_finished():
	emit_signal("finished_execution")
