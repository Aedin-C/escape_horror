extends Area2D
## Area that controls the access to a locker. 
##
## If a player has entered the body, a signal will be sent to the player
## and the player will gain access to the locker. 

signal player_entered
signal player_exited

func _on_locker_body_entered(body: CharacterBody2D):
	emit_signal("player_entered", self)

func _on_locker_body_exited(body: CharacterBody2D):
	emit_signal("player_exited", self)
