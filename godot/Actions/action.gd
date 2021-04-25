extends Node

signal finished
signal type(chr)
signal keystroke(key)
signal mousepos(mouse_pos)

func execute(_args: Dictionary):
	assert("x" in _args)
	assert("y" in _args)
	
	emit_signal("mousepos", Vector2(_args["x"], _args["y"]))
	emit_signal("finished")
