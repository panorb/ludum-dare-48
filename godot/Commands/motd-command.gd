extends "base-command.gd"

func _ready():
	aliases = ["motd"]
	command_description = "Shows the message of the day that can be configured"

func execute(_args):
	send_message("""Hello my son, you wanted to prove your hacking skills to me
So here you go, I set up this shell as a challenge for you.
Find your way around and go [accent]deeper and deeper[/accent] into its folders.

If you don't know where to start, I suggest you type 'help' and press enter ;)""")

	execution_finished()
