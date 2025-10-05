extends Node2D
## Sets the scene so the player is sent to the same floor after death.
##
## Creates a temporary inventory when the player enters/spawns in so items are lost upon death.

func _ready() -> void:
	GameManager.set_scene("res://scenes/floors/vault.tscn")
	GameManager.enter_scene()
