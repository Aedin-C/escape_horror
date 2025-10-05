extends Control
## Menu displayed on player death.

@onready var player = $Player ## Get the player node to access the script.

## If the player respawns, set is_dead to false and respawn the player.
## Reset the current scene using the Global variable.
func _on_respawn_pressed() -> void:
	player.is_dead = false
	
	player.on_respawn()
	get_tree().change_scene_to_file(GameManager.current_scene)

## Return the player to the main menu.
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
