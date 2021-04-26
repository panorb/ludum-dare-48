extends "command.gd"


var aliases : PoolStringArray = ["NULL"]
var command_description : String = ""
var long_description : String = ""

func print_description():
	return "[b]" + name + "[/b] - " + command_description
