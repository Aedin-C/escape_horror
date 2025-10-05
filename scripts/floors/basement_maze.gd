extends Area2D
## Area body for the player to leave the current scene.
##
## When entered, if conditions are met (if applicable), the player can right click to enter the next scene.
## 
## Upon leaving scene, the main player inventory is updated using the temporary inventory
## to save all items the player has collected from that scene.
## Crates are also saved so that items cannot be collected later on if they have already been collected.

var entered = false  ## Body entered by player

func _on_Basement_Maze_body_entered(body: CharacterBody2D):
	entered = true

func _on_Basement_Maze_body_exited(body: CharacterBody2D):
	entered = false

func _physics_process(delta: float):
	if entered == true:
		if Input.is_action_just_pressed("right_click"):
			GameManager.leave_scene()
			SaveManager.promote_temp_to_permanent()

			get_tree().change_scene_to_file("res://scenes/floors/basement_maze.tscn")
