class_name Shell
extends Control

var backlog = []
var command_history = []

var current_command : String = ""
var cursor_index : int = 0
var display_cursor : bool = false
var command_history_position : int = 0

onready var command_parser = get_node("Commands")
onready var file_system = get_node("FileSystem")
onready var margin_container2 = get_node("MarginContainer/MarginContainer")
onready var output_label = get_node("MarginContainer/MarginContainer/Label")

var input_accepted : bool = true
export var main_color : Color = Color("#cccccc")
export var accent_color : Color = Color("#16c60c")
export var error_color : Color = Color("#c50f1f")
export var warning_color : Color = Color("#c19c00")



func _ready():
	command_parser.connect("error_occurred", self, "send_error")
	command_parser.connect("finished_execution", self, "_on_Commands_finished_execution")
	command_parser.connect("message_sent", self, "send_message")
	command_parser.connect("clear_channel", self, "clear_channel")


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
	send(get_last_line(current_command))
	
	if not command_history or command_history and command_history[-1] != current_command:
		command_history.append(current_command)
	
	input_accepted = false
	command_parser.execute(current_command)
	
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
	send("[main]" + msg + "[/main]", display_time, channel)


func send_warning(msg: String, display_time := -1, channel := "main"):
	send("[warning]" + msg + "[/warning]", display_time, channel)


func send_error(msg: String, display_time := -1, channel := "main"):
	send("[error]" + msg + "[/error]", display_time, channel)


func type(chr):
	if input_accepted:
		current_command += chr


func keystroke(key):
	if input_accepted:
		match key:
			"enter":
				if current_command:
					output_label.scroll_following = true
					run_command()
				else:
					# TODO: Play error sound
					pass
			"backspace":
				current_command = current_command.left(current_command.length() - 1)
			"up":
				command_history_position -= 1
				command_from_history()
			"down":
				command_history_position += 1
				command_from_history()


func set_command(cmd: String):
	current_command = cmd

func _on_Commands_finished_execution():
	yield(get_tree().create_timer(0.4), "timeout")
	send_message("")
	input_accepted = true

	yield(get_tree().create_timer(0.1), "timeout")
	output_label.scroll_following = false

func _on_CursorBlinkTimer_timeout():
	display_cursor = !display_cursor
