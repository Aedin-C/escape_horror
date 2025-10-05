extends Area2D
## Informs the player of who's grave they're looking at.

@onready var player = $"../Player"
var entered = false

func on_grave2_entered(body: CharacterBody2D):
	entered = true

func on_grave2_exited(area: CharacterBody2D) -> void:
	entered = false

func _physics_process(delta: float) -> void:
	if entered and Input.is_action_just_pressed("right_click"):
		player.show_message("Jeniffer Rourke\n 1983-2025")
