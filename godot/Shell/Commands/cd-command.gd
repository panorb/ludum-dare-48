extends "base-command.gd"

onready var file_system = get_node("/root/PlayerShell/FileSystem")


func _ready():
	aliases = ["cd"]
	command_description = "Changes the current directory"


func execute(args):
	if args.size() >= 3:
		throw_error("Error: Too many arguments")
		execution_finished()
		return
	
	if args.size() == 1 or args[1].empty() or args[1] == "/":
		# Go to root directory
		file_system.current_directory = "/"
		execution_finished()
		return
	
	var path = args[1]
	path.replace("\\", "/")
	if not file_system.path_exists(path):
		throw_error("Error: No such directory")
	elif file_system.is_file(path):
		throw_error("Error: Path points to a file")
	else:
		file_system.current_directory = file_system.to_absolute_path(path,
				file_system.current_directory)
	
	execution_finished()

