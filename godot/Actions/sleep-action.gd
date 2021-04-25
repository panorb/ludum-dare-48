extends "action.gd"


func execute(action : Dictionary):
	assert("length" in action)
	
	get_tree().create_timer(action["length"]).connect("timeout", self, "_timer_timeout")


func _timer_timeout():
	emit_signal("finished")
