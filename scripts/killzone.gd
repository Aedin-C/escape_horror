extends Area2D
## Area that controls the death of the player. If this area collides with
## the player's hit box, the player dies.

func _on_killzone_body_entered(body: CharacterBody2D) -> void:
	body.die()
