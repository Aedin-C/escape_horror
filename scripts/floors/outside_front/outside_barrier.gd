extends Area2D

var player = null


func _on_Outside_Barrier_body_entered(body: CharacterBody2D) -> void:
	player = body
	player.show_message("You can't leave yet...")
