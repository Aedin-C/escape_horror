extends Area2D

var entered = false

@onready var player = $"../Player"
var b_key = "Basement Key"

func _on_Basement_body_entered(body: CharacterBody2D):
	entered = true

func _on_Basement_body_exited(body: CharacterBody2D):
	entered = false

func _physics_process(delta: float):	
	if entered and (Input.is_action_just_pressed("right_click") or Input.is_action_just_pressed("left_click")):
		player.show_message("It's a metallic door. \n It looks like there's a keyhole in it...")
		JournalManager.add_task("Basement Door", "There's a metallic door by the stairs on the first floor. Seems like it needs a key.")
		if check_key():
			GameManager.leave_scene()
			SaveManager.promote_temp_to_permanent()

			get_tree().change_scene_to_file("res://scenes/floors/basement.tscn")
			

func check_key() -> bool:
	var items = player.get_inv()
	for item in items:
		if item == b_key:
			JournalManager.update_task("Basement Door", "Basement Key was used!")
			return true
	return false
