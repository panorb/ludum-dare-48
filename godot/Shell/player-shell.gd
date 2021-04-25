class_name PlayerShell
extends "shell.gd"

onready var text_edit = get_node("TextEdit")

func _ready():
	text_edit.grab_focus()

	send_message("[accent]=WELCOME User TO LYNUZ(OS)(TM) SUBSYSTEM=[/accent]")


func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_UP:
			keystroke("up")
			_update_textedit()
		elif event.scancode == KEY_DOWN:
			keystroke("down")
			_update_textedit()


func _update_textedit():
	text_edit.text = current_command
	text_edit.cursor_set_column(cursor_index)


func _on_TextEdit_text_changed():
	if "\t" in text_edit.text:
		text_edit.text = text_edit.text.replace("\t", "")
		_update_textedit()

	if "\n" in text_edit.text:
		set_command(text_edit.text.replace("\n", ""))
		keystroke("enter")
		_update_textedit()
	else:
		set_command(text_edit.text)


func _on_TextEdit_cursor_changed():
	if not "\t" in text_edit.text:
		cursor_index = text_edit.cursor_get_column()
