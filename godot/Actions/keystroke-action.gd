extends "action.gd"


func execute(args : Dictionary):
	assert("key" in args)
	
	emit_signal("keystroke", args["key"])
	emit_signal("finished")
