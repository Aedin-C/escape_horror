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
@onready var se_book = "Secret Book" ## Name of the book we want to check for

func _ready() -> void:
	PipeCompletion.s_e = true

func _physics_process(delta: float):	
	if entered and Input.is_action_just_pressed("right_click"):
		if check_inv():
			GameManager.leave_scene()
			SaveManager.promote_temp_to_permanent()

			get_tree().change_scene_to_file("res://scenes/floors/se_basement.tscn")
		else:
			player.show_message("It's a metallic door. \n You should keep exploring before you leave.")
			

## Checks the player's inventory for the required item to open the door.
## Loops through the inventory until it finds the item named "Secret Book."
## If item is found, player is sent to the next scene.
func check_inv() -> bool:
	var items = player.get_inv()
	for item in items:
		if item == se_book:
			return true
	return false


func _on_vault_exit_body_entered(body: CharacterBody2D) -> void:
	entered = true

func _on_vault_exit_body_exited(body: CharacterBody2D) -> void:
	entered = false
