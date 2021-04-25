class_name AdversaryShell
extends "../shell.gd"

var known_behavior_files : PoolStringArray
var active_behavior_file_index : int  = -1
onready var action_parser = get_node("Actions")

func _ready():
	known_behavior_files = _list_files_in_directory("res://Behaviors/")
	
	action_parser.connect("type", self, "type")
	action_parser.connect("keystroke", self, "keystroke")


func _list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file.get_file())

	dir.list_dir_end()

	return files
