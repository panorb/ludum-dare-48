extends "command.gd"

export(NodePath) var file_system_node
onready var file_system = get_node(file_system_node)

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
	var absolute_path = file_system.to_absolute_path(path)
	absolute_path = file_system.resolve_level_up_symbols(absolute_path)
	
	var node = file_system.get_filesystem_node(absolute_path)
	if not node:
		throw_error("Error: No such directory")
	elif file_system.is_file(node):
		throw_error("Error: Path points to a file")
	else:
		file_system.current_directory = absolute_path
	
	execution_finished()

func _on_ssh_change_filesystem():
	file_system = get_node(file_system_node)
