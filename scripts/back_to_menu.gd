extends Area2D
## Area body for the player to leave the current scene.
##
## When entered, the player can right click to send them back to the main menu.

var entered = false  ## Body entered by player

func _on_back_to_menu_body_entered(body: CharacterBody2D) -> void:
	entered = true

func _on_back_to_menu_body_exited(body: Node2D) -> void:
	entered = false

func _physics_process(delta: float) -> void:
	if entered and Input.is_action_just_pressed("right_click"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
