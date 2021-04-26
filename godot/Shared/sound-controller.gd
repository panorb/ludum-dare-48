extends Node

const MUSIC_LAYERS: int = 3
const EFFECT_LAYERS: int = 20
var _effect: Array = []
var _music: Array = []
onready var _tween: Tween = null

# Playback Options
var _loop: bool = true

func _ready() -> void:
	_tween = Tween.new()
	add_child(_tween)
	
	for i in range(MUSIC_LAYERS):
		_music.append(AudioStreamPlayer.new())
		_music[i].bus = str("BGM",i)
		_music[i].volume_db = linear2db(Globals.music_volume)
		add_child(_music[i])
	
	for i in range(EFFECT_LAYERS):
		_effect.append(AudioStreamPlayer.new())
		_effect[i].volume_db= linear2db(Globals.effect_volume)
		_effect[i].bus = str("SFX",i)
		add_child(_effect[i])

func get_audio_effect_player(channel: int) -> AudioStreamPlayer:
	return _effect[channel]

func play_music(filename: String, channel: int = 0, \
	volume : float = -1, should_loop: bool = true) -> void:
	if volume < 0:
		volume = Globals.music_volume
	
	var path = "res://Shared/Music/" + filename
	
	var stream = load(path)
	_music[channel].volume_db = linear2db(volume)
	_music[channel].stop()
	_music[channel].stream = stream
	_music[channel].play()
	_loop=should_loop

func crossfade_music_channels(channel_from : int, channel_to : int):
	var from = _music[channel_from]
	var to = _music[channel_to]
	
	_tween.stop_all()
	_tween.interpolate_property(from, "volume_db", null, -100, 3, Tween.TRANS_LINEAR)
	_tween.interpolate_property(to, "volume_db", null, Globals.music_volume, 0.5, Tween.TRANS_LINEAR)
	_tween.start()

func set_music_volume(channel: int, volume : float = -1):
	if volume < 0:
		volume = Globals.music_volume
	
	_music[channel].volume_db = linear2db(volume)

func set_effect_volume(channel: int, volume : float = -1):
	if volume < 0:
		volume = Globals.effect_volume
		
	_effect[channel].volume_db = linear2db(volume)

func play_effect(filename: String, channel: int = 0, \
	volume : float = -1) -> void:
	if volume < 0:
		volume = Globals.music_volume
	
	var path = "res://Shared/Sounds/" + filename
	
	var stream = load(path)
	_effect[channel].volume_db = linear2db(volume)
	_effect[channel].stop()
	_effect[channel].stream = stream
	_effect[channel].play()


func stop_music()-> void:
	for i in range(MUSIC_LAYERS):
		_music[i].stop()


func stop_effect(channel: int) -> void:
	_effect[channel].stop()


func stop_effects()-> void:
	for i in range(0,EFFECT_LAYERS):
		_effect[i].stop()


func stop_all() -> void:
	stop_music()
	stop_effects()
