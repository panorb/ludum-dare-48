extends Node

export(String) var current_directory = "/"


func to_absolute_path(path, base_path):
	path = path.replace("~", "/home")
	if path.is_abs_path():
		return path
	if not base_path.is_abs_path():
		return ""
		
	if not base_path.ends_with("/"):
		base_path += "/"

	var absolute_path
	if path == "..":
		absolute_path = level_up(base_path)
	elif path.begins_with("../"):
		absolute_path = to_absolute_path(path.lstrip("../"), level_up(base_path))
	elif path == ".":
		absolute_path = base_path
	elif path.begins_with("./"):
		absolute_path = base_path + path.lstrip("./")
	else:
		absolute_path = base_path + path.lstrip("/")
	if not absolute_path.ends_with("/"):
		absolute_path += "/"
	return absolute_path


func to_node_path(path):
	var node_path
	if path == "/":
		node_path = ""
	elif path == "~":
		node_path = "home"
	else:
		node_path = path
	return node_path.lstrip("/").rstrip("/")


func to_file_path(node_path):
	if node_path.empty():
		return "/"
	else:
		return "/" + node_path + "/"


func level_up(directory):
	if not directory == "/":
		directory = directory.rstrip("/")
		var pos_last_slash = directory.find_last("/")
		directory = directory.left(pos_last_slash)
	return directory


func path_exists(path):
	path = to_absolute_path(path, current_directory)
	
	var node_path = to_node_path(path)
	if node_path.empty():
		return true
	var node = get_node_or_null(node_path)
	if not node:
		return false
	else:
		return true


func is_file(path):
	if not path_exists(path):
		return false
	path = to_absolute_path(path, current_directory)
	var node_path = to_node_path(path)
	if node_path.empty():
		return false
	if get_node(node_path) is preload("res://FileSystem/file.gd"):
		return true
	else:
		return false
