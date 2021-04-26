extends "base-command.gd"


func _ready():
	aliases = ["cd"]
	command_description = "Changes the current directory"


func execute(args):
	if args.size() >= 3:
		throw_error("Error: Too many arguments")
		execution_finished()
		return
	
	if args.size() == 1 or not args[1]:
		execution_finished()
		return
	
	if args[1] == "/":
		# Go to root directory
		file_system.current_directory = "/"
		execution_finished()
		return
	
	var path = args[1]
	path.replace("\\", "/")
	var absolute_path = file_system.to_absolute_path(path)
	absolute_path = file_system.resolve_level_up_symbols(absolute_path)
	
	var dir_node = file_system.get_filesystem_node(absolute_path)
	var error = dir_node["error"]
	if error != 0:
		match(error):
			1:
				throw_error("Error: Access denied")
		
			2:
				throw_error("Error: No such directory")
			_:
				throw_error("Unknown error")
	else:
		var node = dir_node["last_node_found"]
		if file_system.is_file(node):
			throw_error("Error: Path points to a file")
		else:
			file_system.current_directory = absolute_path
	
	execution_finished()

