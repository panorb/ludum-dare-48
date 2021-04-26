extends "base-command.gd"

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
	
	var dir_node = file_system.get_filesystem_node(absolute_path)
	var error = dir_node["error"]
	if error:
		match(error):
			1:
				throw_error("Error: Access denied")
		
			2:
				throw_error("Error: Invalid path")
			_:
				throw_error("Unknown error")
	else:
		var node = dir_node["node"]
		if not file_system.is_file(node):
			throw_error("Error: No file")
		elif not file_system.is_text_file(node):
			throw_error("Error: Cannot read binary file")
		else:
			send_message(node.content)
		
	execution_finished()

