extends Area2D
## Area that controls the access to the pipe puzzle. 
##
## If a player has entered the body, a signal will be sent to the player
## and the player will gain access to the puzzle UI.

signal puzzle_entered
signal puzzle_exited

func _on_pipe_puzzle_area_body_entered(body: CharacterBody2D) -> void:
	emit_signal("puzzle_entered", self)

func _on_pipe_puzzle_area_body_exited(body: CharacterBody2D) -> void:
	emit_signal("puzzle_exited", self)
