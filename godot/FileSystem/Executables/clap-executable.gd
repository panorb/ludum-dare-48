extends "../executable.gd"

func execute():
	SoundController.play_effect("clap.wav", -1)
	execution_finished()
