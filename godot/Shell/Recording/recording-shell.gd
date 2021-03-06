class_name RecordingShell
extends "../shell.gd"

const MOUSE_INTERVAL = 0.5

onready var text_edit = get_node("TextEdit")
var recorded_actions : Dictionary = {}
var recording_index = 0

var time_passed = 0
var time_passed_mouse = 0
var recording_active = false


func _ready():
	text_edit.grab_focus()

	send_message("[accent]=WELCOME User TO LYNUZ(OS)(TM) SUBSYSTEM=[/accent]")


func _process(delta):
	if recording_active:
		time_passed += delta
		time_passed_mouse += delta


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
		current_command = text_edit.text.replace("\n", "")
		keystroke("enter")
		_update_textedit()
	
	cursor_index = text_edit.cursor_get_column()
	
	var command_before = current_command.substr(0, cursor_index)
	var command_after = current_command.substr(cursor_index + 1, current_command.length() - cursor_index)
	
	var typed_regex =  "^" + command_before + "(.)" + command_after + "$"
	var backspace_match = command_before + command_after
	
	var regex = RegEx.new()
	regex.compile(typed_regex)
	
	var regex_match = regex.search(text_edit.text)
	
	print(backspace_match)
	if regex_match:
		type(regex_match.strings[1])
	elif text_edit.text == backspace_match:
		keystroke("backspace")
	else:
		set_command(text_edit.text)

func _debug_output(msg: String):
	var debug_output = get_node("Debug/Output")
	debug_output.text = msg

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("record"):
			if recording_active:
				var t = OS.get_datetime()
				var file_name = str(t.year) + "-" + str(t.month) + "-" \
						+ str(t.day) + "-" + str(t.hour) + "-" + str(t.minute) + "-" + str(t.second)
				
				_debug_output("STOP: Outputting to " + file_name + ".json in behaviors directory...")
				
				var save_game = File.new()
				save_game.open("res://Behaviors/" + file_name + ".json", File.WRITE)
				save_game.store_string(JSON.print(recorded_actions, "", true))
				save_game.close()
			else:
				_debug_output("REC: Starting recording...")
				recorded_actions.clear()
				recorded_actions["actions"] = []
			
			recording_active = !recording_active
	
	if event is InputEventMouseMotion:
		if time_passed_mouse > MOUSE_INTERVAL:
			#record_sleep()
			#record({
			#	"action": "hover",
			#	"speed": time_passed_mouse,
			#	"x": event.position.x / get_viewport_rect().size.x,
			#	"y": event.position.y / get_viewport_rect().size.y
			#})
			time_passed_mouse = 0

func record(recording : Dictionary):
	if recording_active:
		print(recording["action"])
		recorded_actions["actions"].append(recording)
		recording_index += 1

func record_sleep():
	if time_passed and recorded_actions["actions"]:
		record({
			"action": "sleep",
			"length": 0.02
		})
	time_passed = 0

func type(chr):
	print("type(" + chr + ")")
	record_sleep()
	record({
		"action": "type",
		"char": chr
	})
	.type(chr)


func keystroke(key):
	print("keystroke(" + key + ")")
	record_sleep()
	record({
		"action": "keystroke",
		"key": key
	})
	.keystroke(key)


func set_command(cmd: String):
	print("set_command(" + cmd + ")")
	record_sleep()
	record({
		"action": "setcommand",
		"cmd": cmd
	})
	.set_command(cmd)


func _on_TextEdit_cursor_changed():
	if not "\t" in text_edit.text:
		cursor_index = text_edit.cursor_get_column()
