extends "action.gd"


func execute(action : Dictionary):
	assert("char" in action)
	
	emit_signal("type", action["char"])
	emit_signal("finished")
