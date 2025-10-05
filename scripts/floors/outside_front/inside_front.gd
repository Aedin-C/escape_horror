extends Area2D

var entered = false

func _ready() -> void:
	GameManager.enter_scene()
	GameManager.current_scene = "res://scenes/floors/outside_front.tscn"

func _on_Inside_Front_body_entered(body: CharacterBody2D):
	entered = true


func _on_Inside_Front_body_exited(body: CharacterBody2D):
	entered = false

func _physics_process(delta: float):
	if entered and Input.is_action_just_pressed("right_click"):
		GameManager.leave_scene()
		SaveManager.promote_temp_to_permanent()
		get_tree().change_scene_to_file("res://scenes/floors/first_floor.tscn")
