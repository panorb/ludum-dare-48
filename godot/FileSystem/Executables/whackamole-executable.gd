extends "../executable.gd"

var executing := false

var cursor_x : int = 0
var cursor_y : int = 0

var moles = [{"x": 1, "y": 1, "time": 5}]

var field_width = 4
var field_height = 4

var cell_width = 7
var cell_height = 3

var score = 0

var empty_line = "-"

var time_passed = 0
var time_passed_last_integer : int = 0

var target_score = 13
var game_length = 12

var cursor_timer = 0.5
var show_cursor = true

var rng = RandomNumberGenerator.new()

func _ready():
	Helper.pause_node(self, true)
	rng.randomize()
	
	empty_line = empty_line.repeat(field_width*(cell_width+1)+1)

func execute():
	time_passed = 0
	time_passed_last_integer = 0
	score = 0
	moles = [{"x": 1, "y": 1, "time": 5}]
	
	render()
	.execute()

func _process(delta):
	time_passed += delta
	cursor_timer -= delta
	
	if time_passed_last_integer != int(time_passed):
		if time_passed_last_integer >= game_length:
			if score >= target_score:
				send_message("[b]Time up![/b] Congratulations! The password is 'nevergonnagiveyouup'")
			else:
				throw_error("[b]Time up![/b] The score doesn't suffice for password access.")
			execution_finished()
			return
		
		if rng.randi_range(0, 2):
			_spawn_random_mole()
		
		time_passed_last_integer = int(time_passed)
		render()
	
	if cursor_timer < 0:
		show_cursor = !show_cursor
		cursor_timer = 0.3
		render()
	
	var to_delete = []
	
	for i in range(len(moles)):
		moles[i]["time"] -= delta
		
		if moles[i]["time"] < 0:
			to_delete.append(i)
	
	to_delete.sort()
	to_delete.invert()
	
	for i in to_delete:
		moles.remove(i)
	
	if to_delete:
		render()

func _spawn_random_mole():
	var x = rng.randi_range(0, field_width - 1)
	var y = rng.randi_range(0, field_height - 1)
	var time = rng.randf_range(2, 4)
	
	if _get_mole_index(x, y) == -1:
		moles.append({
			"x": x,
			"y": y,
			"time": time
		})

func execution_finished():
	clear_channel("whack")
	.execution_finished()


func _input(event):
	if event is InputEventKey:
		var rerender = false
		
		if Input.is_action_just_pressed("ui_cancel"):
			execution_finished()
			return
		
		if Input.is_action_just_pressed("ui_left"):
			cursor_x -= 1
			rerender = true
		if Input.is_action_just_pressed("ui_right"):
			cursor_x += 1
			rerender = true
		if Input.is_action_just_pressed("ui_up"):
			cursor_y -= 1
			rerender = true
		if Input.is_action_just_pressed("ui_down"):
			cursor_y += 1
			rerender = true
		if Input.is_action_just_pressed("ui_accept"):
			var index = _get_mole_index(cursor_x, cursor_y)
			
			if index >= 0:
				score += 1
				rerender = true
				moles.remove(index)
				
				if not moles.size():
					_spawn_random_mole()
					render()
		
		cursor_x = clamp(cursor_x, 0, field_width - 1)
		cursor_y = clamp(cursor_y, 0, field_height - 1)
		
		if rerender:
			render()

func _get_mole(x: int, y: int):
	var index = _get_mole_index(x, y)
	if index >= 0:
		return moles[index]
	
	return null

func _get_mole_index(x: int, y: int):
	for i in range(len(moles)):
		if moles[i]["x"] == x and moles[i]["y"] == y:
			return i
	
	return -1

func render():
	clear_channel("whack")
	send_message("Timer: " + str(time_passed_last_integer) + "/" + str(game_length), -1, "whack")
	send_message("Score: " + str(score) + "/" + str(target_score), -1, "whack")
	render_playing_field()

func render_playing_field():
	send_message(empty_line, -1, "whack")
	for i in range(field_height):
		var line = "|"
		
		for j in range(field_width):
			var field_char = " "
			if cursor_x == j and cursor_y == i and show_cursor:
				field_char = "█"
			elif _get_mole_index(j, i) != -1:
				field_char = "X" 
			
			line += field_char.repeat(cell_width)
			line += "|"
		
		line += "\n"
		
		send_message(line.repeat(cell_height).rstrip("\n"), -1, "whack")
		send_message(empty_line, -1, "whack")

