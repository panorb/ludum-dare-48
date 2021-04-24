extends "base-command.gd"


func _ready():
	aliases = ["ssh", "connect"]


func execute(_args):
	send_message("Not implemented.")
	emit_signal("command_finished")
