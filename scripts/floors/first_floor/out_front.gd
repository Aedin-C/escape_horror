extends Area2D

var entered = false


func _on_Out_Front_body_entered(body: CharacterBody2D):
	entered = true

func _on_Out_Front_body_exited(body: CharacterBody2D):
	entered = false

func _physics_process(delta: float):
	if entered == true:
		$"../Player".show_message("The door is locked.")
