class_name AdversaryShell
extends "../shell.gd"


var known_behavior_files : PoolStringArray
var active_behavior_file_index : int  = -1

onready var action_parser = get_node("Actions")
# Debug only
onready var debug_behavior_script = get_node("Debug/BehaviorScript")


func _ready():
	action_parser.connect("type", self, "type")
	action_parser.connect("keystroke", self, "keystroke")
	
	known_behavior_files = _list_files_in_directory("res://Behaviors/")

func _process(_delta):
	if active_behavior_file_index >= 0:
		debug_behavior_script.text = known_behavior_files[active_behavior_file_index]
	else:
		debug_behavior_script.text = "[No script]"

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_left"):
			active_behavior_file_index -= 1
		if event.is_action_pressed("ui_right"):
			active_behavior_file_index += 1
		
		active_behavior_file_index = int(clamp(active_behavior_file_index, -1, known_behavior_files.size() - 1))
		
		if event.is_action_pressed("ui_accept") and active_behavior_file_index >= 0:
			run_behavior_script()


func type(chr):
	.type(chr)
	cursor_index += 1

func run_behavior_script():
	var file_path = "res://Behaviors/" + known_behavior_files[active_behavior_file_index]
	
	var file = File.new()
	assert(file.file_exists(file_path))
	
	file.open(file_path, File.READ)
	var behavior = JSON.parse(file.get_as_text()).result
	assert(behavior.size() > 0)
	
	file.close()
	action_parser.execute(behavior)


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
			files.append(file)

	dir.list_dir_end()

	return files
