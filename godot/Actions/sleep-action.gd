extends "action.gd"


func execute(args : Dictionary):
	assert("length" in args)
	
	get_tree().create_timer(args["length"]).connect("timeout", self, "_timer_timeout")


func _timer_timeout():
	emit_signal("finished")
