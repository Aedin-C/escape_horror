extends Area2D
## Area body for the player to leave the current scene.
##
## When entered, if conditions are met (if applicable), the player can right click to enter the next scene.
## 
## Upon leaving scene, the main player inventory is updated using the temporary inventory
## to save all items the player has collected from that scene.
## Crates are also saved so that items cannot be collected later on if they have already been collected.

var entered = false ## Body entered by player

## Alert the player that some of the walls have fallen, causing paths to be blocked.
func _ready() -> void:
	$"../Player".show_message("The place is starting to collapse! \n Some of the walls have fallen.")


func _on_to_maze_body_entered(body: CharacterBody2D) -> void:
	entered = true

func _on_to_maze_body_exited(body: CharacterBody2D) -> void:
	entered = false

func _physics_process(delta: float):	
	if entered and Input.is_action_just_pressed("right_click"):
		GameManager.leave_scene()
		SaveManager.promote_temp_to_permanent()

		get_tree().change_scene_to_file("res://scenes/floors/se_maze.tscn")
