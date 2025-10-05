extends Area2D

var entered = false

@onready var player = $"../Player"
var b_key = "Basement Key"

func _on_Basement_body_entered(body: CharacterBody2D):
	entered = true

func _on_Basement_body_exited(body: CharacterBody2D):
	entered = false

func _physics_process(delta: float):	
	if entered and Input.is_action_just_pressed("right_click"):
		player.show_message("It's a metallic door. \n It looks like there's a keyhole in it...")
		if check_key():
			GameManager.leave_scene()
			SaveManager.promote_temp_to_permanent()

			get_tree().change_scene_to_file("res://scenes/floors/basement.tscn")
			

func check_key() -> bool:
	var items = player.get_inv()
	for item in items:
		if item == b_key:
			player.show_message("You used the basement key!")
			return true
	return false
