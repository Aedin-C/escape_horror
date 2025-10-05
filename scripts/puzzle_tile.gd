extends Area2D
## Areas used as tiles for the tile puzzle. Different tiles may affect more than itself.
##
## Change the colour of the tile when selected using an overlay (ColorRect).
##
## When the player enters the body of a tile and right clicks, the tile will display 
## the interaction by toggling the overlay. 

@export var overlay_color_default: Color = Color(1, 1, 1, 0)
@export var overlay_color_selected: Color = Color(0, 0, 0.6, 0.3)

var is_selected = false ## Boolean determining if the tile has been selected
var player_on_tile = false ## Boolean determining if the player is on that tile

@onready var overlay = $ColorRect ## Get the ColorRect node for overlaying colours.

## Ensure overlays are transparent by default.
func _ready():
	overlay.color = overlay_color_default

## Toggle the tile if the player is on that tile and has right clicked.
## Check the solution after some allotted time based on the machine.
func _process(delta):
	if player_on_tile and Input.is_action_just_pressed("right_click"):
		toggle_tile()
	await get_tree().create_timer(0.001*delta).timeout
	get_parent().check_solution()
 
## Reverse the selection of the tile (true = false, false = true) and set the overlay
## colour with respect to the state of the is_selected variable.
func toggle_tile():
	is_selected = !is_selected
	overlay.color = overlay_color_selected if is_selected else overlay_color_default

func _on_tile_body_entered(body: CharacterBody2D):
	player_on_tile = true

func _on_tile_body_exited(body: CharacterBody2D):
	player_on_tile = false
