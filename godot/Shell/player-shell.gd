class_name PlayerShell
extends "shell.gd"

var command_history_position = 0

onready var text_edit = get_node("TextEdit")

func _ready():
	text_edit.grab_focus()
	
	send_message("[accent]=WELCOME User TO LYNUZ(OS)(TM) SUBSYSTEM=[/accent]")


func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_UP:
			command_history_position -= 1
			command_from_history()
		elif event.scancode == KEY_DOWN:
			command_history_position += 1
			command_from_history()


func command_from_history():
	if command_history_position >= 0:
		command_history_position = 0
		return
	
	if command_history_position < -command_history.size():
		command_history_position = -command_history.size()
		return
	
	var cmd = command_history[command_history.size() + command_history_position]
	
	if current_command != cmd:
		text_edit.text = cmd
		current_command = cmd
		
		text_edit.cursor_set_column(len(cmd))

func _on_CursorBlinkTimer_timeout():
	display_cursor = !display_cursor

func _on_TextEdit_text_changed():
	if "\n" in text_edit.text:
		current_command = text_edit.text.split("\n")[0]
		
		if current_command:
			output_label.scroll_following = true
			run_command(current_command)
		else:
			# TODO: Play error sound
			pass
		
		current_command = ""
		text_edit.text = ""
	else:
		current_command = text_edit.text

func _on_Commands_finished_execution():
	yield(get_tree().create_timer(0.4), "timeout")
	send_message("")
	._on_Commands_finished_execution()
	yield(get_tree().create_timer(0.1), "timeout")
	output_label.scroll_following = false


func _on_TextEdit_cursor_changed():
	cursor_index = text_edit.cursor_get_column()
