extends Node

var valid_adresses = [
	{
		"username": "benjamin",
		"ip": "10.234.122.64",
		"fs": "res://FileSystem/PlayerFileSystem.tscn",
		"tag": "player"
	},
	{
		"username": "jochen",
		"ip": "10.19.57.187",
		"fs": "res://FileSystem/Adversary/AdversaryFileSystem.tscn",
		"tag": "adv"
	},
	{
		"username": "ending",
		"ip": "123.43.212.21",
		"fs": "res://FileSystem/EndingFileSystem.tscn",
		"tag": "end"
	}]

func _ready():
	for i in range(len(valid_adresses)):
		valid_adresses[i]["fs_scene"] = load(valid_adresses[i]["fs"])
	

var music_volume: float = 1
var effect_volume: float = 1

