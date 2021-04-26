class_name Shell
extends Control

var world_node = null

var backlog = []
var command_history = []

var current_command : String = ""
var cursor_index : int = 0
var display_cursor : bool = false
var command_history_position : int = 0

onready var command_parser = get_node("Commands")
onready var action_parser = get_node("Actions")
onready var margin_container2 = get_node("MarginContainer/MarginContainer")
onready var output_label = get_node("MarginContainer/MarginContainer/Label")
var file_system : Node

var input_accepted : bool = true
var block_player_input := true

export var muted : bool = false
export var main_color : Color = Color("#cccccc")
export var accent_color : Color = Color("#16c60c")
export var error_color : Color = Color("#c50f1f")
export var warning_color : Color = Color("#c19c00")

signal exit_shell


func _ready():
	command_parser.connect("error_occurred", self, "send_error")
	command_parser.connect("message_sent", self, "send_message")
	command_parser.connect("clear_channel", self, "clear_channel")
	command_parser.connect("finished_execution", self, "_on_Commands_finished_execution")
	command_parser.connect("ssh_connect", self, "ssh_connect")
	command_parser.connect("allow_input", self, "_on_Commands_allow_input")
	command_parser.connect("exit_shell", self, "_on_Commands_exit_shell")
	
	command_parser.connect("trigger_behavior", self, "run_behavior_script")
	
	action_parser.connect("type", self, "type")
	action_parser.connect("keystroke", self, "keystroke")
	action_parser.connect("mousepos", self, "set_mouse_position")
	action_parser.connect("message", self, "send_message")
	action_parser.connect("input_allow", self, "set_input_accepted")

func _process(delta):
	output_label.bbcode_text = ""
	
	var to_delete = []
	
	for i in range(backlog.size()):
		if backlog[i]["time_left"] != -1:
			backlog[i]["time_left"] -= delta
			
			if backlog[i]["time_left"] < 0:
				to_delete.append(i)
		
		output_label.bbcode_text += backlog[i]["msg"] + "\n"
	
	if input_accepted:
		var displayed_cmd = current_command
		
		if display_cursor:
			if cursor_index < displayed_cmd.length():
				displayed_cmd[cursor_index] = "█"
			else:
				displayed_cmd += "█"
		
		output_label.bbcode_text += get_last_line(displayed_cmd)
	
	output_label.bbcode_text = insert_colors(output_label.bbcode_text)
	
	delete_indexes(to_delete)

func initialize(world : Node):
	world_node = world
	self.connect("exit_shell", world_node, "default_view")


func clear_channel(channel: String):
	if channel == '*':
		backlog.clear()
	else:
		var to_delete = []
		for i in range(backlog.size()):
			if backlog[i]["channel"] == channel:
				to_delete.append(i)
		
		delete_indexes(to_delete)


func delete_indexes(indexes):
	indexes.sort()
	indexes.invert()
	
	for i in indexes:
		backlog.remove(i)


func run_command():
	if not command_parser.is_executing():
		if not command_history or (command_history and command_history[-1] != current_command):
			command_history.append(current_command)
	
	if input_accepted:
		send(get_last_line(current_command))	
		command_parser.input(current_command)
	
	current_command = ""


func insert_colors(text: String):
	text = insert_color(text, "main", main_color)
	text = insert_color(text, "accent", accent_color)
	text = insert_color(text, "error", error_color)
	text = insert_color(text, "warning", warning_color)
	return text


func insert_color(text: String, name: String, color: Color):
	text = text.replace("[" + name + "]", "[color=#" + color.to_html() + "]")
	text = text.replace("[/" + name + "]", "[/color]")
	return text


func command_from_history():
	if command_history_position >= 0:
		command_history_position = 0
		current_command = ""
		cursor_index = 0
		return
	
	if command_history_position < -command_history.size():
		command_history_position = -command_history.size()
		return
	
	var cmd = command_history[command_history.size() + command_history_position]
	
	if current_command != cmd:
		current_command = cmd
		cursor_index = len(current_command)


func get_last_line(displayed_cmd : String):
	if command_parser.is_executing():
		return "[main]" + displayed_cmd + "[/main]"
	else:
		return "[accent]" + file_system.current_directory + "[/accent]\n" \
			+ "λ [main]" + displayed_cmd + "[/main]"


func get_cur_dir_line():
	return "[accent]" + file_system.current_directory + "[/accent]\n"


#func render_line(original_text):
#	var reg_exp_bbCodes = "#\\[[^\\]]+\\]#"
#	var regex = RegEx.new()
#	regex.compile(reg_exp_bbCodes)
#	var text = regex.sub(original_text, "", true)
#	var container_width = margin_container2.rect.x - output_label.get_font("normal_font").get_char_size('█')
#	
#	var minimum_num_chars = floor(container_width
#			/ output_label.get_font("bold_font").get_char_size('W', 'W'))
#	var maximum_num_chars = floor(container_width
#			/ output_label.get_font("normal_font").get_char_size('.', '.'))
#	
#	var current_line = text.substr(0, minimum_num_chars)
#	var current_line_bbb = ""
#	
#	for i in range(minimum_num_chars, maximum_num_chars):
#		
#	
#	
#	if output_label.get_font("normal_font").get_string_size(text).x >= margin_container2.rect.x - 3:
#		original_text += "\n"

func send(msg: String, display_time := -1, channel := "main"):
	backlog.append({
					"msg": msg,
					"time_left": display_time,
					"channel": channel
				   })

func send_message(msg: String, display_time := -1, channel := "main"):
	_play_sound_effect("send-message.wav", 1)
	send("[main]" + msg + "[/main]", display_time, channel)


func send_warning(msg: String, display_time := -1, channel := "main"):
	_play_sound_effect("send-message.wav", 1)
	send("[warning]" + msg + "[/warning]", display_time, channel)


func send_error(msg: String, display_time := -1, channel := "main"):
	_play_sound_effect("error-message.wav", 1)
	send("[error]" + msg + "[/error]", display_time, channel)


func type(chr):
	current_command += chr
	cursor_index += 1


func keystroke(key):
	match key:
		"enter":
			if current_command:
				output_label.scroll_following = true
				_play_sound_effect("command-send.wav")
				run_command()
			else:
				_play_sound_effect("error.wav")
		"backspace":
			if not current_command:
				_play_sound_effect("empty-backspace.wav")
				return
			
			current_command = current_command.left(current_command.length() - 1)
		"up":
			command_history_position -= 1
			command_from_history()
		"down":
			command_history_position += 1
			command_from_history()


func set_command(cmd: String):
	current_command = cmd

func run_behavior_script(name: String):
	var file_path = "res://Behaviors/" + name + ".json"
	
	var file = File.new()
	assert(file.file_exists(file_path))
	
	file.open(file_path, File.READ)
	var behavior = JSON.parse(file.get_as_text()).result
	assert(behavior.size() > 0)
	
	file.close()
	action_parser.execute(behavior)

func _play_sound_effect(filename: String, channel: int = 0):
	if not muted:
		SoundController.play_effect(filename, channel)


func _on_Commands_finished_execution():
	if backlog:
		send_message("")
	else:
		_play_sound_effect("send-message.wav")
	input_accepted = true

	yield(get_tree().create_timer(0.1), "timeout")
	output_label.scroll_following = block_player_input


func _on_CursorBlinkTimer_timeout():
	display_cursor = !display_cursor


func ssh_connect(adress: Dictionary):
	if file_system:
		file_system.queue_free()
	yield(get_tree(), "idle_frame")
	
	var file_system_scene = load(adress["fs"])
	file_system = file_system_scene.instance()
	self.add_child(file_system)
	
	command_parser.update_file_system(file_system)


func _on_Commands_allow_input(allow: bool):
	input_accepted = allow


func set_block_player_input(block: bool):
	block_player_input = block

func _on_Commands_exit_shell():
	emit_signal("exit_shell")

