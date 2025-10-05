extends Area2D
## Informs the player of who's grave they're looking at.

@onready var player = $"../Player"
var entered = false

func _on_grave_1_body_entered(body: CharacterBody2D) -> void:
	entered = true

func _on_grave_1_body_exited(body: CharacterBody2D) -> void:
	entered = false

func _physics_process(delta: float) -> void:
	if entered and Input.is_action_just_pressed("right_click"):
		player.show_message("Dorothy Rourke\n 1983-2025")
