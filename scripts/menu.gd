extends Control
## Menu scene that allows the player to play the game, experience the tutorial, or exit the game.

## Start the game by sending the player to the beginning scene.
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/floors/beginning.tscn")

## Load the tutorial by sending the player to the tutorial scene.
func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/floors/tutorial.tscn")

## Exit the game.
func _on_quit_pressed() -> void:
	get_tree().quit()
