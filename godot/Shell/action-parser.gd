extends Node

signal type(chr)
signal keystroke(key)
signal behavior_finished
signal mousepos(mouse_pos)
signal message(text, time)
signal input_allow(allow)

var _behavior
var _action_index := 0

func _ready():
	for node in get_children():
		node.connect("finished", self, "_on_Action_finished")
		node.connect("type", self, "_on_Action_type")
		node.connect("keystroke", self, "_on_Action_keystroke")
		node.connect("message", self, "_on_Action_message")
		node.connect("input_allow", self, "_on_Action_input_allow")
		

func execute(behavior: Dictionary):
	_behavior = behavior["actions"]
	_action_index = 0
	
	_run_current_action()

func _run_current_action():
	var cur_action = _get_current_action() 
	
	assert("action" in cur_action)
	assert(has_node(cur_action["action"]))
	
	var node = get_node(cur_action["action"])
	node.execute(cur_action)

func _get_current_action():
	return _behavior[_action_index]

func _on_Action_finished():
	_action_index += 1
	
	if _action_index >= _behavior.size():
		emit_signal("behavior_finished")
	else:
		_run_current_action()

func _on_Action_type(chr):
	emit_signal("type", chr)


func _on_Action_keystroke(key):
	emit_signal("keystroke", key)


func _on_Action_mousepos(key):
	emit_signal("mousepos", key)


func _on_Action_message(text, time):
	emit_signal("message", text, time)


func _on_Action_input_allow(allow):
	emit_signal("input_allow", allow)
