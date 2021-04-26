extends Node


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


func pause_node(node: Node, pause : bool):
	node.set_process(!pause)
	node.set_process_input(!pause)
	node.set_process_unhandled_input(!pause)
	node.set_process_unhandled_key_input(!pause)
	node.set_physics_process(!pause)

func get_adress_from_fs(fs: Node):
	for adress in Globals.valid_adresses:
		if adress["fs"] == fs.filename:
			return adress
	
	return null
