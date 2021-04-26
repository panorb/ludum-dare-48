extends Node

export(bool) var access_permission = true
export(String) var password = ""
export(String) var behavior_name = ""

func get_fs_name():
	return name.replace('|', '.')

func is_unlocked():
	return access_permission and not password

func unlock():
	if not access_permission:
		return false
	password = ""
	return true

func lock(string):
	if not access_permission:
		return false
	password = string
	return true
