class_name Shell
extends Control

var backlog : PoolStringArray = []
var command_history : PoolStringArray = []

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
	command_parser.connect("error_occurred", self, "_on_Commands_error_occurred")
	command_parser.connect("finished_execution", self, "_on_Commands_finished_execution")
	command_parser.connect("message_sent", self, "_on_Commands_message_sent")


func _process(_delta):
	output_label.bbcode_text = ""
	
	for line in backlog:
		output_label.bbcode_text += line + "\n"
		
	if input_accepted:
		var displayed_cmd = current_command
		
		if display_cursor:
			if cursor_index < displayed_cmd.length():
				displayed_cmd[cursor_index] = "█"
			else:
				displayed_cmd += "█"
		
		output_label.bbcode_text += get_last_line(displayed_cmd)
	
	output_label.bbcode_text = insert_colors(output_label.bbcode_text)


func run_command():
	backlog.append(get_last_line(current_command))
	
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


func send_message(msg: String):
	backlog.append("[main]" + msg + "[/main]")


func send_warning(msg: String):
	backlog.append("[warning]" + msg + "[/warning]")


func send_error(msg: String):
	backlog.append("[error]" + msg + "[/error]")


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


func _on_Commands_message_sent(msg: String):
	send_message(msg)


func _on_Commands_error_occurred(msg):
	backlog.append("[color=red]" + msg + "[/color]")


func _on_Commands_finished_execution():
	yield(get_tree().create_timer(0.4), "timeout")
	send_message("")
	yield(get_tree().create_timer(0.1), "timeout")
	
	output_label.scroll_following = false
	input_accepted = true


func _on_CursorBlinkTimer_timeout():
	display_cursor = !display_cursor
