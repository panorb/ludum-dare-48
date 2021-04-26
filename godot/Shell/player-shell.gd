class_name PlayerShell
extends "shell.gd"

onready var text_edit = get_node("TextEdit")
onready var animation_player = get_node("AnimationPlayer")

func _ready():
	block_player_input = false
	text_edit.grab_focus()
	
	action_parser.connect("behavior_finished", self, "_on_Actions_behavior_finished")
	command_parser.connect("play_animation", self, "_on_Commands_play_animation")
	animation_player.play("startup")
	
	run_behavior_script("start")

func _unhandled_input(event):
	if event is InputEventKey and not block_player_input:
		if event.scancode == KEY_UP:
			keystroke("up")
			_update_textedit()
		elif event.scancode == KEY_DOWN:
			keystroke("down")
			_update_textedit()
		if event.scancode == KEY_BACKSPACE and not cursor_index:
			_play_sound_effect("empty-backspace.wav")
			pass
		


func _update_textedit():
	text_edit.text = current_command
	text_edit.cursor_set_column(cursor_index)


func _on_TextEdit_text_changed():
	if not input_accepted or block_player_input:
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

func run_behavior_script(name: String):
	block_player_input = true
	.run_behavior_script(name)

func _on_TextEdit_cursor_changed():
	if not "\t" in text_edit.text:
		cursor_index = text_edit.cursor_get_column()

func _on_Actions_behavior_finished():
	block_player_input = false

func _on_Commands_play_animation(animation_name: String):
	animation_player.play(animation_name)
