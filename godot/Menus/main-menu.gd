extends Control

signal exit_game
signal start_game

var world_node = null

onready var music_volume_slider = get_node("MarginContainer/HBoxContainer/VBoxContainer2/MusicVolumeSettings/MusicVolumeSlider")
onready var effect_volume_slider = get_node("MarginContainer/HBoxContainer/VBoxContainer2/EffectVolumeSettings/EffectVolumeSlider")
onready var exit_button = get_node("MarginContainer/HBoxContainer/VBoxContainer/ExitButton")
onready var animation_player = get_node("AnimationPlayer")

func _ready():
	SoundController.play_music("main-menu-background.mp3", 0, 
			Globals.music_volume, true)
	music_volume_slider.value = Globals.music_volume
	effect_volume_slider.value = Globals.effect_volume
	exit_button.visible = OS.get_name() != "HTML5"
	animation_player.play("startup")

func initialize(world : Node):
	world_node = world
	self.connect("exit_game", world_node, "exit_game")
	self.connect("start_game", world_node, "start_game")

func _on_ExitButton_pressed():
	emit_signal("exit_game")

func _on_StartButton_pressed():
	SoundController.stop_music()
	emit_signal("start_game")

func _on_MusicVolumeSlider_value_changed(value):
	Globals.music_volume = value
	SoundController.set_music_volume(0, value)

func _on_EffectVolumeSlider_value_changed(value):
	Globals.effect_volume = value
	SoundController.play_effect("error.wav")


func _on_AnimationPlayer_animation_finished(anim_name):
	animation_player.play("cursor_loop")
