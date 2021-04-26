extends "action.gd"


func execute(args : Dictionary):
	assert("text" in args)
	
	var time = -1
	if "time" in args:
		time = args["time"]
	
	emit_signal("message", args["text"], time)
	emit_signal("finished")
