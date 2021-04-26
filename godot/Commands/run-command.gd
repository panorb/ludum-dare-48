extends "base-command.gd"

export(NodePath) var file_system_node
onready var file_system = get_node(file_system_node)
var in_execution : Node = null

func _ready():
	aliases = ["run"]


func execute(args):
	if args.size() >= 3:
		throw_error("Error: Too many arguments")
		execution_finished()
		return
	
	if args.size() == 1 or args[1].empty():
		throw_error("Error: Missing argument")
		execution_finished()
		return
	
	var path = ""
	var absolute_path = ""
	path = args[1]
	path.replace("\\", "/")
	absolute_path = file_system.to_absolute_path(path)
	absolute_path = file_system.resolve_level_up_symbols(absolute_path)
	
	var node = file_system.get_filesystem_node(absolute_path)
	if not node:
		throw_error("Error: Invalid path")
	elif not file_system.is_file(node):
		throw_error("Error: No file")
	elif not file_system.is_executable(node):
		throw_error("Error: File is not executable")
	else:
		in_execution = node
		in_execution.connect("finished", self, "_on_Executable_finished")
		in_execution.connect("error", self, "_on_Executable_error")
		in_execution.connect("message", self, "_on_Executable_message")
		in_execution.connect("clear_channel", self, "_on_Executable_clear_channel")
		in_execution.execute()
		return
		
	execution_finished()

func _on_Executable_error(msg: String, display_time : float, channel : String):
	throw_error(msg, display_time, channel)
	
func _on_Executable_message(msg: String, display_time : float, channel : String):
	send_message(msg, display_time, channel)

func _on_Executable_finished():
	execution_finished()
	in_execution = null

func _on_Executable_clear_channel(channel: String):
	clear_channel(channel)

