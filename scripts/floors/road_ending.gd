extends Node2D
## Scene for the first part of the ending of the game. 
##
## The scene will begin with an animation and a message alerting the player of their failure.
##
## Upon the animation's completion, the player will be send to the second part of the ending.

@onready var player = $ThePlayer ## Get the player node to call on functions

## Display message when scene is loaded, adjust the display time accordingly.
func _ready() -> void:
	player.narration_box.display_time = 2
	player.show_message("You tried to run \nbut you weren't fast enough.")

## Send the player to the next scene when the animation is finished.
func _on_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/floors/backyard_ending.tscn")
