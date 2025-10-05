extends Node2D
## Sets the scene so the player is sent to the same floor after death.
##
## Creates a temporary inventory when the player enters/spawns in so items are lost upon death.
##
## If the player is in the secret ending, remove the monsters (roamers) from the scene.


@onready var player = $Player
@onready var roamers = $Roamers

func _ready() -> void:
	GameManager.set_scene("res://scenes/floors/road.tscn")
	GameManager.enter_scene()
	if PipeCompletion.s_e:
		remove_child(roamers)
