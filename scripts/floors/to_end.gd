extends Area2D
## Area body for the player to leave the current scene.
##
## When entered, if conditions are met (if applicable), the player can right click to enter the next scene.
## 
## Upon leaving scene, the main player inventory is updated using the temporary inventory
## to save all items the player has collected from that scene.
## Crates are also saved so that items cannot be collected later on if they have already been collected.

var entered = false ## Body entered by player
@onready var player = $"../Player" ## Get the player node to call on functions
## Names of the keys we want to check for
var a_key = "Attic Key"
var b_key = "Basement Key" 
var g_key = "Greenhouse Key"

func _on_to_end_body_entered(body: CharacterBody2D) -> void:
	entered = true

func _on_to_end_body_exited(body: CharacterBody2D) -> void:
	entered = false

func _physics_process(delta: float) -> void:
	if entered and (Input.is_action_just_pressed("right_click") or Input.is_action_just_pressed("left_click")):
		if checkComplete():
			GameManager.leave_scene()
			SaveManager.promote_temp_to_permanent()

			get_tree().change_scene_to_file("res://scenes/floors/tunnel.tscn")
		else: 
			player.show_message("You examine the mysterious bookshelf. \n It appears to have three \nkeyholes and requires power.")
			JournalManager.add_task("Bookcase", "A mysterious opening. You feel a draft of air through the bookshelf. It seems to require 3 keys to open.")

## Checks the player's inventory for the required key to open the door.
## Loops through the inventory until it finds the items named 
## "Attic Key", "Basement Key", and "Greenhouse Key."
## Also checks if the pipe puzzle has been completed. If all are true,
## then the player is sent to the next scene.
func checkComplete():
	var items = player.get_inv()
	var has_akey = false
	var has_bkey = false
	var has_gkey = false
	
	for item in items:
		if item == a_key:
			has_akey = true
		elif item == b_key:
			has_bkey = true
		elif item == g_key:
			has_gkey = true
	
	if has_akey and has_bkey and has_gkey and PipeCompletion.pipe_complete:
		JournalManager.update_task("Bookcase", "You used all 3 keys!")
		return true	
	return false
