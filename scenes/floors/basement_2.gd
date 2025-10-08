extends Node2D
## Sets the scene so the player is sent to the same floor after death.
##
## Creates a temporary inventory when the player enters/spawns in so items are lost upon death.

func _ready() -> void:
	GameManager.set_scene("res://scenes/floors/basement2.tscn")
	GameManager.enter_scene()
	JournalManager.add_task("Bookcase", "Now that you have power, it's time to open the bookcase in the back of the library. Hopefully you can leave.")
