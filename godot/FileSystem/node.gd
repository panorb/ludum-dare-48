extends Node

export(bool) var access_permission = true


func get_fs_name():
	return name.replace('|', '.')
