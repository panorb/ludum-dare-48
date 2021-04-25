extends Node

signal finished
signal type(chr)
signal keystroke(key)

func execute(_args: Dictionary):
	emit_signal("finished")
