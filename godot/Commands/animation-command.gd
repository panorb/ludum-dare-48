extends "command.gd"


export var command_description : String
export var animation_name : String
export(Array, String) var aliases = []

export(float, 0.1, 2.0) var delay : float
export(float, 0, 2.0) var interval : float

var animation_files = []
var frame_counter = 0

var playing = false

func _ready():
	animation_files = Helper.list_files_in_directory("res://Animations/" + animation_name)
	animation_files.sort()

func execute(_args):
	assert(animation_files.size() > 0)
	
	playing = true
	frame_counter = 0
	get_tree().create_timer(delay).connect("timeout", self, "_frame_timer_timeout")

func next_frame():
	frame_counter += 1
	var frame_index = _get_frame_index()
	
	# Read frame from file
	var file_path = "res://Animations/" + animation_name + "/" + animation_files[frame_index]
	
	var file = File.new()
	assert(file.file_exists(file_path))
	
	file.open(file_path, File.READ)
	var text = file.get_as_text()
	assert(text.length() > 0)
	file.close()
	
	clear_channel(animation_name)
	send_message(text, -1, animation_name)
	get_tree().create_timer(interval).connect("timeout", self, "_frame_timer_timeout")

func _input(event):
	if event is InputEventKey and playing:
		if frame_counter > 1:
			clear_channel(animation_name)
			execution_finished()
			playing = false

func _frame_timer_timeout():
	if playing:
		next_frame()

func print_description():
	return name + " - " + command_description

func _get_frame_index():
	return frame_counter % animation_files.size()
