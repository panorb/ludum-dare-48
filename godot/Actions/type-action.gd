extends "action.gd"


func execute(args : Dictionary):
	assert("char" in args)
	
	emit_signal("type", args["char"])
	emit_signal("finished")
