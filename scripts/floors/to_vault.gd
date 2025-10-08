extends Area2D
## Area body for the player to leave the current scene.
##
## When entered, if conditions are met (if applicable), the player can right click to enter the next scene.
## 
## Upon leaving scene, the main player inventory is updated using the temporary inventory
## to save all items the player has collected from that scene.
## Crates are also saved so that items cannot be collected later on if they have already been collected.

var entered = false ## Body entered by player

func _on_to_vault_body_entered(body: CharacterBody2D) -> void:
	JournalManager.add_task("Vault Door", "A mysterious door, looks like it needs a code and power.")
	entered = true

func _on_to_vault_body_exited(body: CharacterBody2D) -> void:
	entered = false

## Alert the player on the state of the vault door. 
## Different messages for no power and no keypad code. 
## If code is correct and power is on, player is sent to the next scene.
func _physics_process(delta: float) -> void:
	if PipeCompletion.secret_pipe_complete:
		JournalManager.update_task("Vault Door", "There's power to the vault door!")
	
	if entered and (Input.is_action_just_pressed("right_click") or Input.is_action_just_pressed("left_click")):
		if not (PipeCompletion.keypad_complete):
			$"../Player".show_message("The mysterious door is locked. \n Looks like it need some kind of code.")
		elif not PipeCompletion.secret_pipe_complete:
			JournalManager.update_task("Vault Door", "Code entered! Just need some power.")
			$"../Player".show_message("The mysterious door is unlocked. \n Looks like it needs power.")
		else:
			GameManager.leave_scene()
			SaveManager.promote_temp_to_permanent()
			get_tree().change_scene_to_file("res://scenes/floors/vault.tscn")
