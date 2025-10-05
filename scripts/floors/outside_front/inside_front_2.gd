extends Area2D

var entered = false

func _on_Inside_Front2_body_entered(body: CharacterBody2D):
	entered = true

func _on_Inside_Front2_body_exited(body: CharacterBody2D):
	entered = false

func _physics_process(delta: float):
	if entered == true:
		if Input.is_action_just_pressed("right_click"):
			get_tree().change_scene_to_file("res://scenes/floors/first_floor.tscn")
