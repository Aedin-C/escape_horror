extends Node2D
## Give some information to the player about the tutorial when it's loaded.
## Provide a message and adjust the display time for the message and following messages.

@onready var player = $Player ## Get the player node to access the script.

func _ready() -> void:
	player.narration_box.display_time = 5
	player.show_message("Welcome to the tutorial. To begin, \nwalk up to the drawer on the left \nand right click to open \nand left click to claim the item. \n e to open inventory.")
	player.narration_box.display_time = 2
