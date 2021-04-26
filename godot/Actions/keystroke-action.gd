extends "action.gd"


func execute(args : Dictionary):
	assert("key" in args)
	
	emit_signal("finished")
	emit_signal("keystroke", args["key"])
