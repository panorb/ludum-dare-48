extends "action.gd"


func execute(args : Dictionary):
	assert("x" in args)
	assert("y" in args)
	
	emit_signal("mousepos", Vector2(args["x"], args["y"]))
	emit_signal("finished")
