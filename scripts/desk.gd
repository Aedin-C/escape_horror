extends Area2D
## Area that controls the access to a desk. 
##
## If a player has entered the body, a signal will be sent to the player
## and the player will gain access to the desk. 

@onready var desk_ui = $DeskUI ## Get the desk ui node to access

signal desk_area_entered
signal desk_area_exited

## Add desks to a group in case there's multiple on a scene.
func _ready():
	add_to_group("desks")

func _on_desk_body_entered(body: CharacterBody2D) -> void:
	emit_signal("desk_area_entered", self)


func _on_desk_body_exited(body: CharacterBody2D) -> void:
	emit_signal("desk_area_exited", self)
