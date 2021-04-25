extends "action.gd"


func execute(action : Dictionary):
	assert("key" in action)
	
	emit_signal("keystroke", action["key"])
	emit_signal("finished")
