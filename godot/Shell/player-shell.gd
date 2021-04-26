class_name PlayerShell
extends "shell.gd"

onready var text_edit = get_node("TextEdit")
onready var command_cat = get_node("Commands/cat")
onready var command_cd = get_node("Commands/cd")
onready var command_ls = get_node("Commands/ls")
onready var command_ssh = get_node("Commands/ssh")

func _ready():
	current_ssh = "benjamin"
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
		
		if event.scancode == KEY_BACKSPACE and not current_command:
			_play_sound_effect("empty-backspace.wav")
			pass
		


func _update_textedit():
	text_edit.text = current_command
	text_edit.cursor_set_column(cursor_index)


func _on_TextEdit_text_changed():
	if not input_accepted:
		_update_textedit()
		return
	
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

func _on_ssh_change_filesystem(adress):
	file_system.queue_free()
	yield(get_tree(), "idle_frame")
	var adversary_file_system = load(adress["fs"])
	file_system = adversary_file_system.instance()
	self.add_child(file_system)
	command_ls.file_system = file_system
	command_cd.file_system = file_system
	command_cat.file_system = file_system
	command_ssh.file_system = file_system
	
	current_ssh = adress["username"]
	
	
