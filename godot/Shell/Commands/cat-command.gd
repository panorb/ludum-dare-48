extends "base-command.gd"


func _ready():
	aliases = ["cat"]


func execute(_args):
	send_message("Not implemented.")
	emit_signal("command_finished")
