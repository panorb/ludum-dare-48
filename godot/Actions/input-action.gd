extends "action.gd"


func execute(args : Dictionary):
	assert("allow" in args)
	emit_signal("input_allow", args["allow"])
	emit_signal("finished")
