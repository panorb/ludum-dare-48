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

func get_filesystem_node(absolute_path):
	var path_elements = absolute_path.split("/", false)
	
	if path_elements.empty():
		return self
	
	var parent_node = self
	
	while path_elements:
		var node_name = path_elements[0]
		path_elements.remove(0)
		
		var child_found = false
		for child in parent_node.get_children():
			if child.get_fs_name() == node_name:
				if is_file(child) and not path_elements.empty():
					return null
				else:
					child_found = true
					parent_node = child
					break
		if not child_found:
			return null
			
	return parent_node
		
func points_to_file(absolute_path):
	return is_file(get_filesystem_node(absolute_path))

func points_to_directory(absolute_path):
	return is_directory(get_filesystem_node(absolute_path))

func is_file(node):
	return node is preload("res://FileSystem/file.gd")
	
func is_directory(node):
	return node is preload("res://FileSystem/folder.gd")
