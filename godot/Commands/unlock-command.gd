extends "base-command.gd"

var filesystem_node = null
var input_allowed = false

func _ready():
	aliases = ["unlock"]
	command_description = "Unlocks files and folders if provided the correct password"
	long_description = """Unlocks files and folders if provided the correct password

unlock [filepath]
unlock [folderpath]

[b]Valid usage examples:[/b]
unlock Documents
unlock ../Documents
unlock mytax.txt
"""

func execute(args):
	if args.size() >= 3:
		throw_error("Error: Too many arguments")
		execution_finished()
		return
	
	if args.size() == 1 or args[1].empty():
		throw_error("Error: Too few arguments")
		execution_finished()
		return
	
	var path = args[1]
	path.replace("\\", "/")
	var absolute_path = file_system.to_absolute_path(path)
	absolute_path = file_system.resolve_level_up_symbols(absolute_path)
	
	var dir_node = file_system.get_filesystem_node(absolute_path)
	var error = dir_node["error"]
	filesystem_node = dir_node["last_node_found"]
	if error:
		match(error):
			1:
				request_password()
			2:
				throw_error("Error: Invalid path")
				execution_finished()
			_:
				throw_error("Unknown error")
				execution_finished()
	else:
		throw_error("Error: File or directory already unlocked")
		execution_finished()

func input(input):
	allow_input(false)
	
	send_message("Trying to unlock ...")
	yield(get_tree().create_timer(0.4), "timeout")
	
	if not filesystem_node.access_permission:
		throw_error("Error: Unaccessible")
		execution_finished()
		return
	
	if (filesystem_node.password == input):
		if filesystem_node.unlock():
			if file_system.is_file(filesystem_node):
				send_message("File successfully unlocked")
			elif file_system.is_directory(filesystem_node):
				send_message("Directory successfully unlocked")
			else:
				send_message("Unlocked")
		else:
			if file_system.is_file(filesystem_node):
				throw_error("Error: File could not be unlocked")
			elif file_system.is_directory(filesystem_node):
				throw_error("Error: Directory could not be unlocked")
			else:
				throw_error("Error: Could not be unlocked")
		execution_finished()
	else:
		request_password()

func request_password():
	send_message("Please input password or press ESC to abort: ")
	allow_input(true)

func allow_input(allow: bool):
	input_allowed = allow
	.allow_input(allow)

func _input(event):
	if input_allowed:
		if event is InputEventKey:
			if event.pressed and event.scancode == KEY_ESCAPE:
				allow_input(false)
				execution_finished()
