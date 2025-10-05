extends Area2D
## Informs the player that they cannot enter the door to go to the "back basement."

@onready var player = $"../Player"

func _on_basement_back_body_entered(body: CharacterBody2D) -> void:
	player.show_message("The door is locked shut. \nLooks like you'll have to go\n around to get back there.")
