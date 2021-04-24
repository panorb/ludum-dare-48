extends "shell.gd"
class_name PlayerShell

var display_cursor : bool = false

onready var text_edit = get_node("TextEdit")
onready var margin_container2 = get_node("MarginContainer/MarginContainer")
onready var output_label = get_node("MarginContainer/MarginContainer/Label")

func _ready():
	text_edit.grab_focus()

func _process(_delta):
	output_label.bbcode_text = ""
	
	for line in backlog:
		output_label.bbcode_text += line + "\n"
		
	if input_accepted:
		output_label.bbcode_text += get_last_line()
		
		if display_cursor:
			output_label.bbcode_text += "█"
	
	output_label.bbcode_text = insert_colors(output_label.bbcode_text)
	
	if input_accepted:
		yield(get_tree(), "idle_frame")
		output_label.scroll_following = false

func _on_CursorBlinkTimer_timeout():
	display_cursor = !display_cursor

func _on_TextEdit_text_changed():
	if "\n" in text_edit.text:
		current_command = text_edit.text.split("\n")[0]
		
		if current_command:
			backlog.append(get_last_line())
			run(current_command)
		else:
			# TODO: Play error sound
			pass
		
		current_command = ""
		text_edit.text = ""
	else:
		current_command = text_edit.text
