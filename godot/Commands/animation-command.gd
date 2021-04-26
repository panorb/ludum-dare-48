extends "command.gd"

export var command_description : String
export(Array, String) var aliases = []

export var default_anim : String = "player"
export(float, 0.1, 2.0) var delay : float
export(float, 0, 2.0) var interval : float

var animation_files = []
var frame_counter = 0

var playing = false

func execute(_args):
	assert(animation_files.size() > 0)
	
	playing = true
	frame_counter = 0
	get_tree().create_timer(delay).connect("timeout", self, "_frame_timer_timeout")

func update_file_system(fs: Node):
	var tag = Helper.get_adress_from_fs(fs)["tag"]
	.update_file_system(fs)
	_load_animation_files(tag)

func _load_animation_files(tag: String):
	var dir = Directory.new()
	var path = "res://Animations/" + name + "-" + tag
	
	if dir.dir_exists(path):
		animation_files = Helper.list_files_in_directory(path)
		for i in range(len(animation_files)):
			animation_files[i] = path + "/" + animation_files[i]
		animation_files.sort()
	else:
		_load_animation_files(default_anim)

func next_frame():
	frame_counter += 1
	var frame_index = _get_frame_index()
	
	# Read frame from file
	var file_path = animation_files[frame_index]
	
	var file = File.new()
	assert(file.file_exists(file_path))
	
	file.open(file_path, File.READ)
	var text = file.get_as_text()
	assert(text.length() > 0)
	file.close()
	
	clear_channel(name)
	send_message(text, -1, name)
	get_tree().create_timer(interval).connect("timeout", self, "_frame_timer_timeout")

func _input(event):
	if event is InputEventKey and playing:
		if frame_counter > 1:
			clear_channel(name)
			execution_finished()
			playing = false

func _frame_timer_timeout():
	if playing:
		next_frame()

func print_description():
	return name + " - " + command_description

func _get_frame_index():
	return frame_counter % animation_files.size()
