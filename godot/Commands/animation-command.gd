extends "command.gd"


export var command_description : String
export var animation_name : String
export(float, 0, 2.0) var intervall : float


func print_description():
	return name + " - " + command_description
