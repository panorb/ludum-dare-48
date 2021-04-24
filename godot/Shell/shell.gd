extends Control

var backlog : PoolStringArray = []
var command_history : PoolStringArray = []
var scroll_position : int = 0

var display_cursor : bool = false
var input_accepted : bool = true
var current_command : String = ""

onready var output_label = get_node("MarginContainer/MarginContainer/Label")


func _ready():
	backlog.append("=WELCOME User TO LYNUZ(OS)(TM) SUBSYSTEM=")

func _process(delta):
	output_label.bbcode_text = ""
	
	for line in backlog:
		output_label.bbcode_text += line + "\n"
		
	if input_accepted:
		output_label.bbcode_text += "[color=red]>[/color] "
		output_label.bbcode_text += current_command
		
		if display_cursor:
			output_label.bbcode_text += "█"

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			var scancode_string = OS.get_scancode_string(event.scancode)
			if scancode_string.length() == 1:
				if event.shift:
					current_command += scancode_string.to_upper()
				else:
					current_command += scancode_string.to_lower()

func _on_CursorBlinkTimer_timeout():
	display_cursor = !display_cursor
