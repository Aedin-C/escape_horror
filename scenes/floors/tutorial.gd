extends Node2D
## Give some information to the player about the tutorial when it's loaded.
## Provide a message and adjust the display time for the message and following messages.

@onready var player = $Player ## Get the player node to access the script.

func _ready() -> void:
	player.narration_box.display_time = 5
	player.show_message("Welcome to the tutorial. \nTo begin, press j to view your current task.")
	player.narration_box.display_time = 2
	
	JournalManager.add_task("Tutorial", "This is the journal. Various tasks will appear here to help keep you on track. Mainly messages that appear to you as you play will appear in the journal. \nNow that you know how the journal works, press j to close and walk up to the drawer on the left and click to open and click again to claim the item. E to open inventory.")
