extends Area2D

var entered = false


func _on_Attic_body_entered(body: CharacterBody2D):
	entered = true

func _on_Attic_body_exited(body: CharacterBody2D):
	entered = false

func _physics_process(delta: float):
	if entered == true:
		if Input.is_action_just_pressed("right_click"):
			GameManager.leave_scene()
			SaveManager.promote_temp_to_permanent()
			get_tree().change_scene_to_file("res://scenes/floors/attic.tscn")
			
