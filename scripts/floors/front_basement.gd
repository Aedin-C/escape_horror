extends Area2D
## Area body for the player to leave the current scene.
##
## When entered, if conditions are met (if applicable), the player can right click to enter the next scene.
## 
## Upon leaving scene, the main player inventory is updated using the temporary inventory
## to save all items the player has collected from that scene.
## Crates are also saved so that items cannot be collected later on if they have already been collected.

@onready var player = $"../Player"
var entered = false ## Body entered by player
var message_shown = false

## Don't show the message again.
func _ready() -> void:
	if PipeCompletion.pipe_complete or PipeCompletion.secret_pipe_complete:
		message_shown = true

func _on_Front_Basement_body_entered(body: CharacterBody2D):
	entered = true

func _on_Front_Basement_body_exited(body: CharacterBody2D):
	entered = false

func _physics_process(delta: float):
	if not message_shown:
		if PipeCompletion.pipe_complete:
			player.show_message("You hear a click. \n Did something unlock?")
			JournalManager.update_task("Maze Door", "There's power to the maze door!")
			JournalManager.update_task("Back Basement Door", "There's power to the back basement door!")
			message_shown = true
		elif PipeCompletion.secret_pipe_complete:
			player.show_message("You hear a loud groan from within the walls. \n What just got powered?")
			JournalManager.update_task("Vault Door", "There's power to the vault door!")
			message_shown = true
	if entered:
		JournalManager.add_task("Maze Door", "Go to the console on the left to give power!")
		if PipeCompletion.pipe_complete and (Input.is_action_just_pressed("right_click") or Input.is_action_just_pressed("left_click")):
			GameManager.leave_scene()
			SaveManager.promote_temp_to_permanent()
			get_tree().change_scene_to_file("res://scenes/floors/basement2.tscn")
		else:
			player.show_message("A metallic door. \n Looks like it needs power to open.")
