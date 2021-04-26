extends "action.gd"

var queue = []

func execute(args : Dictionary):
	assert("queue" in args)
	queue = args["queue"]
	
	emit_signal("finished")
	emit_signal("input_allow", false)
	_next_message()

func _next_message():
	var message = queue.pop_front()
	
	var time = -1
	if "time" in message:
		time = message["time"]
	
	if time != -1:
		get_tree().create_timer(time).connect("timeout", self, "_timer_timeout")
	else:
		_timer_timeout()
	
	emit_signal("message", message["text"], time)


func _timer_timeout():
	if queue:
		_next_message()
	else:
		emit_signal("input_allow", true)
