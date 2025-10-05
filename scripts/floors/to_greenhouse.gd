extends Area2D
## Area body for the player to leave the current scene.
##
## When entered, if conditions are met (if applicable), the player can right click to enter the next scene.
## 
## Upon leaving scene, the main player inventory is updated using the temporary inventory
## to save all items the player has collected from that scene.
## Crates are also saved so that items cannot be collected later on if they have already been collected.

@onready var player = $"../Player" ## Get the player node to call on functions
var g_key = "Greenhouse Key" ## Name of the key we want to check for
var entered = false ## Body entered by player

func _on_to_greenhouse_body_entered(body: CharacterBody2D):
	entered = true

func _on_to_greenhouse_body_exited(body: CharacterBody2D):
	entered = false

func _physics_process(delta: float):
	if entered and Input.is_action_just_pressed("right_click"):
		player.show_message("It's a metallic door. \n It looks like there's a keyhole in it...")
		if check_key():
			GameManager.leave_scene()
			SaveManager.promote_temp_to_permanent()

			get_tree().change_scene_to_file("res://scenes/floors/greenhouse.tscn")

## Checks the player's inventory for the required key to open the door.
## Loops through the inventory until it finds the item named "Greenhouse Key."
## If item is found,the player is sent to the next scene.
func check_key() -> bool:
	var items = player.get_inv()
	for item in items:
		if item == g_key:
			player.show_message("You used the greenhouse key!")
			return true
	return false
