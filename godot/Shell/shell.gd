extends Control

var backlog : PoolStringArray = []
var command_history : PoolStringArray = []

var display_cursor : bool = false
var input_accepted : bool = true
var command_handled : bool = false

var current_command : String = ""

onready var output_label = get_node("MarginContainer/MarginContainer/Label")


func _ready():
	backlog.append("[color=#16c60c]=WELCOME User TO LYNUZ(OS)(TM) SUBSYSTEM=[/color]")

func _process(_delta):
	output_label.bbcode_text = ""
	
	for line in backlog:
		output_label.bbcode_text += line + "\n"
		
	if input_accepted:
		output_label.bbcode_text += get_last_line()
		
		if display_cursor:
			output_label.bbcode_text += "█"
	elif not command_handled:
		command_handled = true
		backlog.append("Stalling...")
		yield(get_tree().create_timer(0.2), "timeout")
		input_accepted = true
	
func get_last_line():
	if input_accepted:
		return "" + current_command
	else:
		return backlog[-1]

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
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
			

func _on_CursorBlinkTimer_timeout():
	display_cursor = !display_cursor
