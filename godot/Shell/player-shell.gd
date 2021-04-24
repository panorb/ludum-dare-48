extends "shell.gd"
class_name PlayerShell

var display_cursor : bool = false

onready var text_edit = get_node("TextEdit")
onready var margin_container2 = get_node("MarginContainer/MarginContainer")
onready var output_label = get_node("MarginContainer/MarginContainer/Label")

func _ready():
	text_edit.grab_focus()
	
	send_message("[accent]=WELCOME User TO LYNUZ(OS)(TM) SUBSYSTEM=[/accent]")

func _process(_delta):
	output_label.bbcode_text = ""
	
	for line in backlog:
		output_label.bbcode_text += line + "\n"
		
	if input_accepted:
		output_label.bbcode_text += get_last_line()
		
		if display_cursor:
			output_label.bbcode_text += "█"
	
	output_label.bbcode_text = insert_colors(output_label.bbcode_text)

func _on_CursorBlinkTimer_timeout():
	display_cursor = !display_cursor

func _on_TextEdit_text_changed():
	if "\n" in text_edit.text:
		current_command = text_edit.text.split("\n")[0]
		
		if current_command:
			output_label.scroll_following = true
			run(current_command)
		else:
			# TODO: Play error sound
			pass
		
		current_command = ""
		text_edit.text = ""
	else:
		current_command = text_edit.text

func _on_Commands_finished_execution():
	print("_on_Commands_finished_execution()")
	
	yield(get_tree().create_timer(0.4), "timeout")
	send_message("")
	._on_Commands_finished_execution()
	yield(get_tree().create_timer(0.1), "timeout")
	output_label.scroll_following = false
