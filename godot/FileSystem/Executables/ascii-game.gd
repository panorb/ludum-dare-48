extends "../executable.gd"

var current_alternatives = []
	
func execute():
	var json_dict = parse_file("ascii-game")
	assert("title" in json_dict)
	send_message(json_dict["title"])
	
	assert("chapter" in json_dict)
	process_chapter(json_dict["chapter"])


func parse_file(file_name: String):
	var file_path = "res://Adventures/" + file_name + ".json"
	
	var file = File.new()
	assert(file.file_exists(file_path))
	
	file.open(file_path, File.READ)
	var story = JSON.parse(file.get_as_text()).result
	assert(story.size() > 0)
	
	file.close()
	return story

func process_chapter(chapter):
	assert("prologue" in chapter)
	send_message("[b]" + chapter["prologue"] + "[/b]")
	
	assert("alternatives")
	process_alternatives(chapter["alternatives"])

func process_alternatives(alternatives):
	if alternatives.empty():
		send_message("[b]-- The End --[/b]")
		execution_finished()
		return
	
	# Print descriptions
	var count = alternatives.size()
	for i in range(count):
		assert("description" in alternatives[i])
		var description = alternatives[i]["description"]
		send_message("[accent]" + str(i+1) + ": " + description+ "[/accent]")
	current_alternatives = alternatives
	send_message("Enter your choice or press ESC to abort:")
	allow_input(true)
	
func input(input):
	allow_input(false)
	var max_value = current_alternatives.size()
	if max_value == 0: # Should not happen
		execution_finished()
		return
	if not input.is_valid_integer():
		throw_error("Invalid choice. Try again!")
		allow_input(true)
		return
	var input_number = int(input)
	
	if input_number < 1 or input_number > max_value:
		throw_error("Invalid choice. Try again!")
		allow_input(true)
		return
	
	assert("chapter" in current_alternatives[input_number-1])
	process_chapter(current_alternatives[input_number-1]["chapter"])
	
