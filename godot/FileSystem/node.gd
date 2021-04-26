extends Node

export(bool) var access_permission = true
export(String) var password = ""

func get_fs_name():
	return name.replace('|', '.')


func is_unlocked():
	return access_permission and not password
