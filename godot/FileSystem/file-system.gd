extends Node

export(String) var current_directory = "/"


func to_absolute_path(path):
	if path.begins_with("~"):
		path = "/home" + path.lstrip("~")
	if path.begins_with(".") and not path.begins_with(".."):
		path = current_directory + path.lstrip(".")
	
	if path.is_abs_path():
		return path
	var absolute_path = current_directory.rstrip("/") + "/" + path.rstrip("/")

	return absolute_path

func resolve_level_up_symbols(absolute_path):
	if not absolute_path.is_abs_path():
		return absolute_path
	
	var path = absolute_path.lstrip("/").rstrip("/")
	var path_elements = path.split("/", false)
	var i = 0
	while i < path_elements.size():
		if path_elements[i] == "..":
			path_elements.remove(i)
			if i > 0:
				# remove one level higher
				path_elements.remove(i-1)
				i -= 1
		else:
			i += 1
	
	var final_path = "/"
	for element in path_elements:
		final_path += element + "/"
	
	if final_path != "/":
		final_path = final_path.rstrip("/")
	return final_path

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

# Return -1 for not existent, 0 for directory, 1 for file
func check_path(absolute_path):
	var base_dir = absolute_path.get_base_dir()
	var last_element_name = absolute_path.get_file()
	var node_path_base_dir = to_node_path(base_dir)
	
	var parent_node
	if node_path_base_dir.empty():
		if last_element_name.empty():
			return 0
		else:
			parent_node = self
	else:
		parent_node = get_node_or_null(node_path_base_dir)
	if not parent_node:
		return -1
	else:
		for child in parent_node.get_children():
			if child.get_fs_name() == last_element_name:
				if child is preload("res://FileSystem/file.gd"):
					return 1
				else:
					return 0
		
	return -1
		
func is_file(absolute_path):
	if check_path(absolute_path) == 1:
		return true
	else:
		return false
