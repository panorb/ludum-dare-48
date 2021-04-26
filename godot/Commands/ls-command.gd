extends "base-command.gd"

func _ready():
	aliases = ["ls", "dir"]
	command_description = "Prints all the files and directories in a directory"


func execute(args):
	if args.size() >= 3:
		throw_error("Error: Too many arguments")
		execution_finished()
		return
	
	var path = ""
	var absolute_path = ""
	if args.size() == 1 or args[1].empty():
		absolute_path = file_system.current_directory
	else:
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
		var node = dir_node["last_node_found"]
		if file_system.is_file(node):
			throw_error("Error: Path points to a file")
		else:
			print_content(node)

	execution_finished()
		
func print_content(dir_node):
	for child in dir_node.get_children():
		if file_system.is_directory(child):
			send_message("[accent]" + child.get_fs_name() + "[/accent]")
		elif file_system.is_file(child):
			send_message("[main]" + child.get_fs_name() + "[/main]")


