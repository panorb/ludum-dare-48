extends "command.gd"


var aliases : PoolStringArray = ["NULL"]
var command_description : String = ""


func print_description():
	return name + " - " + command_description
