extends "command.gd"

var enabled = true

signal change_filesystem

export(NodePath) var file_system_node
onready var file_system = get_node(file_system_node)

func _ready():
	aliases = ["ssh", "connect"]
	command_description = "Log into a remote machine and execute commands"

func execute(args):
	if not enabled:
		throw_error("Error: Command disabled")
		execution_finished()
		return
	
	if args.size() >= 3:
		throw_error("Error: Too many arguments")
		execution_finished()
		return
	
	if args.size() == 1 or args[1].empty():
		throw_error("Error: Missing argument")
		execution_finished()
		return
	
	var ssh_command = args[1]
	var ssh_command_elements = ssh_command.split("@")
	
	
	if ssh_command_elements.size() != 2:
		throw_error("Error: Invalid argument")
		execution_finished()
		return
	
	var username = ssh_command_elements[0]
	var ip_address = ssh_command_elements[1]
	
	var regex_ip = RegEx.new()
	regex_ip.compile("\\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.|$)){4}\\b")
	
	if not regex_ip.search(ip_address):
		throw_error("Error: Invalid IP address")
		execution_finished()
		return
	
	send_message("Connecting ...")
	yield(get_tree().create_timer(0.4), "timeout")
	
	if ip_address != Globals.adversary_ip_address:
		throw_error("Error: Could not connect to host")
		execution_finished()
		return
	
	if username != Globals.adversary_username:
		throw_error("Error: Unknown user")
		execution_finished()
		return
	
	send_message("Logged in at " + username + "@" + ip_address)
	emit_signal("change_filesystem")
	enabled = false
	execution_finished()
