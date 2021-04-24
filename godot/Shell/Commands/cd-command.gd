extends "base-command.gd"

onready var file_system = get_node("/root/Shell/FileSystem")

func _ready():
	aliases = ["cd"]
	command_description = "Changes the current directory"
	
func execute(args):
	if args.size() >= 3:
		throw_error("Error: Too many arguments")
		execution_finished()
		return
	
	if args.size() == 1 or args[1].empty():
		# Go to root directory
		file_system.current_directory = "/"
		execution_finished()
		return
	
	var path = args[1]
	if path.begins_with("."):
		path = file_system.current_directory + path.lstrip("./")

	path.replace("\\", "/")

	if not args[1].ends_with("/"):
		path += "/"

	if path.is_rel_path():
		path = file_system.current_directory + path

	path = path.lstrip("/")
	
	var directory_node = file_system.get_node_or_null(path)
	if not directory_node:
		throw_error("Error: No such directory")
	else:
		file_system.current_directory = "/" + path
	
	execution_finished()
		
	
	
	
	
	
	
	
		
		
		
