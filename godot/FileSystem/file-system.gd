extends Node

export(String) var current_directory = "/"

func _process(_delta):
	print(current_directory)
	pass
	
func to_absolute_path(path):
	if path.is_abs_path():
		return path

	if path.begins_with("~"):
		path = "/home" + path.lstrip("~")
	if path.begins_with(".") and not path.begins_with(".."):
		path = current_directory + path.lstrip(".")
		
	var absolute_path = current_directory.rstrip("/") + "/" + path.rstrip("/")

	return absolute_path

func resolve_level_up_symbols(absolute_path):
	if not absolute_path.is_abs_path():
		return absolute_path
	
	var path_elements = absolute_path.strip("/")
	var i = 0
	while i < path_elements.size():
		if path_elements[i] == "..":
			path_elements.remove(i)
			if i > 0:
				# remove one level higher
				path_elements.remove(i-1)
		else:
			i += 1
	
	var final_path = "/"
	for element in path_elements:
		final_path += element + "/"
	
	return final_path.rstrip("/")

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
		return "/" + node_path


func level_up(directory):
	if not directory == "/":
		directory = directory.rstrip("/")
		var pos_last_slash = directory.find_last("/")
		directory = directory.left(pos_last_slash)
	return directory

func path_exists(absolute_path):
	var node_path = to_node_path(absolute_path)
	if node_path.empty():
		return true
	var node = get_node_or_null(node_path)
	if not node:
		return false
	else:
		return true
		
func is_file(absolute_path):
	if not path_exists(absolute_path):
		return false
	var node_path = to_node_path(absolute_path)
	if node_path.empty():
		return false
	if get_node(node_path) is preload("res://FileSystem/file.gd"):
		return true
	else:
		return false
