extends Node

signal type(chr)
signal keystroke(key)


func _ready():
	for node in get_children():
		node.connect("finished", self, "_on_Action_finished")
		node.connect("type", self, "_on_Action_type")
		node.connect("keystroke", self, "_on_Action_keystroke")


func _on_Action_finished():
	pass


func _on_Action_type(chr):
	emit_signal("type", chr)


func _on_Action_keystroke(key):
	emit_signal("keystroke", key)
