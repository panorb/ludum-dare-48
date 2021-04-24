extends Control
class_name Shell

var backlog : PoolStringArray = []
var command_history : PoolStringArray = []

var current_command : String = ""

onready var command_parser = get_node("Commands")
onready var file_system = get_node("FileSystem")

var input_accepted : bool = true
export var main_color : Color = Color("#cccccc")
export var accent_color : Color = Color("#16c60c")
export var error_color : Color = Color("#c50f1f")
export var warning_color : Color = Color("#c19c00")

func _ready():
	command_parser.connect("error_occurred", self, "_on_Commands_error_occurred")
	command_parser.connect("finished_execution", self, "_on_Commands_finished_execution")
	command_parser.connect("message_sent", self, "_on_Commands_message_sent")

func run(cmd: String):
	backlog.append(get_last_line())
	
	if command_history and command_history[-1] != cmd:
		command_history.append(cmd)
	
	input_accepted = false
	command_parser.execute_command(cmd)

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

func get_last_line():
	return "[accent]" + file_system.current_directory + "[/accent]\n" \
		+ "λ [main]" + current_command + "[/main]"

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

func _on_Commands_message_sent(msg: String):
	send_message(msg)

func _on_Commands_error_occurred(msg):
	backlog.append("[color=red]" + msg + "[/color]")

func _on_Commands_finished_execution():
	input_accepted = true
	
