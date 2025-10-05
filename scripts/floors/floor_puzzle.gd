extends Area2D
## Kills the player when the collision shape is entered.

func _on_floor_puzzle_body_entered(body: CharacterBody2D):
	body.die()
