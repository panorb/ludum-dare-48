extends Control

var backlog : PoolStringArray = []
var command_history : PoolStringArray = []

var display_cursor : bool = false
var input_accepted : bool = true
var command_handled : bool = false

var current_command : String = ""

onready var margin_container2 = get_node("MarginContainer/MarginContainer")
onready var output_label = get_node("MarginContainer/MarginContainer/Label")
onready var command_parser = get_node("Commands")

export var main_color : Color = Color("#cccccc")
export var accent_color : Color = Color("#16c60c")
export(int, 12, 24) var font_size : int 

func _ready():
	backlog.append("[accent]=WELCOME User TO LYNUZ(OS)(TM) SUBSYSTEM=[/accent]")

func _process(_delta):
	output_label.bbcode_text = ""
	
	for line in backlog:
		output_label.bbcode_text += line + "\n"
		
	if input_accepted:
		output_label.bbcode_text += get_last_line()
		
		if display_cursor:
			output_label.bbcode_text += "█"
	elif not command_handled:
		output_label.scroll_following = true
		command_handled = true
		command_parser.execute_command(current_command)
	
	output_label.bbcode_text = insert_color(output_label.bbcode_text, "accent", accent_color)
	output_label.bbcode_text = insert_color(output_label.bbcode_text, "main", main_color)
	
	if input_accepted:
		yield(get_tree(), "idle_frame")
		output_label.scroll_following = false

func insert_color(text, name, color):
	text = text.replace("[" + name + "]", "[color=#" + color.to_html() + "]")
	text = text.replace("[/" + name + "]", "[/color]")
	return text

func get_last_line():
	if input_accepted:
		return "λ [main]" + current_command + "[/main]"
	else:
		return backlog[-1]

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and input_accepted:
			var scancode = event.scancode
			var scancode_string = OS.get_scancode_string(scancode)
			
			if scancode_string.length() == 1:
				if event.shift:
					current_command += scancode_string.to_upper()
				else:
					current_command += scancode_string.to_lower()
			
			if scancode == KEY_SPACE:
				current_command += " "
			
			if scancode == KEY_BACKSPACE:
				current_command = current_command.substr(0, current_command.length() - 1)
			
			if scancode == KEY_ENTER and current_command:
				backlog.append(get_last_line())
				command_handled = false
				input_accepted = false

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

func _on_CursorBlinkTimer_timeout():
	display_cursor = !display_cursor

func _on_Commands_message_sent(msg):
	backlog.append("[main]" + msg + "[/main]")

func _on_Commands_error_occurred(msg):
	backlog.append("[color=red]" + msg + "[/color]")

func _on_Commands_finished_execution():
	yield(get_tree(), "idle_frame")
	input_accepted = true
	

