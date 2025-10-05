extends Area2D
## Area that controls the access to the keypad.
##
## If the player enters the body, a signal will be passed to the player
## and the keypad will be accessed there.

signal keypad_area_entered
signal keypad_area_exited

func _on_keypad_area_body_entered(body: CharacterBody2D) -> void:
	emit_signal("keypad_area_entered", self)

func _on_keypad_area_body_exited(body: CharacterBody2D) -> void:
	emit_signal("keypad_area_exited", self)
