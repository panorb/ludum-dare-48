extends Node

signal finished
signal type(chr)
signal keystroke(key)
signal mousepos(mouse_pos)
signal message(text, time)
signal input_allow(allow)

func execute(_args: Dictionary):
	emit_signal("finished")
