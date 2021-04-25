extends "command.gd"

export(NodePath) var file_system_node
onready var file_system = get_node(file_system_node)

func _ready():
	aliases = ["cat"]
	command_description = "Displays the content of a file"

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
	elif not "content" in node:
		throw_error("Error: Cannot read binary file")
	else:
		send_message(node.content)
		
	execution_finished()

func _on_ssh_change_filesystem():
	file_system = get_node(file_system_node)
