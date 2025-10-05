extends Panel
## Controls the slots of the pipe puzzle.
##
## Includes logic for rotating of pipes and their connections with others
## as well as the flow of power between them.

@export_enum("Straight", "Corner", "Cross", "SemiCross") var pipe_type := "Straight" ## Names the pipe types. Straight is the default
@onready var pipe_display: Sprite2D = $CenterContainer/Panel/PipeDisplay ## Access the sprite node for the pipes

var rotation_index := 0  ## Default rotation of the item
signal pipe_rotated ## Signals if the pipe has been rotated

var is_powered = false ## Pipes don't have power by default

## Loads the textures and rotations of the pipes. 
## Filter for mouse input and signals.
func _ready():
	update_pipe_texture()
	pipe_display.rotation_degrees = rotation_index * 90
	mouse_filter = MOUSE_FILTER_STOP  # Ensure clicks go to this panel

## If a pipe slot is clicked on, rotate the pipe texture of that slot.
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rotation_index = (rotation_index + 1) % 4
		pipe_display.rotation_degrees = rotation_index * 90
		pipe_rotated.emit()

## Loads the pipe textures.
func update_pipe_texture():
	var item: InvItem
	match pipe_type:
		"Straight":
			item = preload("res://assets/inventory/items/straight_pipe.tres")
		"Corner":
			item = preload("res://assets/inventory/items/corner_pipe.tres")
		"Cross":
			item = preload("res://assets/inventory/items/cross_pipe.tres")
		"SemiCross":
			item = preload("res://assets/inventory/items/semi_cross_pipe.tres")
		_:
			return
	
	if item and item.texture:
		pipe_display.texture = item.texture
	else:
		push_error("Missing or null texture for " + pipe_type)

## Sets the connections that a pipe has as well as the locations of those connections.
## Connections are for determining if a pipe is connected to another pipe for power flow.
func get_connections() -> Array[int]:
	# 0=Up, 1=Right, 2=Down, 3=Left
	match pipe_type:
		"Straight":
			return [0, 2] if rotation_index % 2 == 0 else [1, 3]
		"Corner":
			# Corner pipes connect current direction and next clockwise
			return [rotation_index, (rotation_index + 1) % 4]
		"SemiCross":
			# A SemiCross connects in 3 directions (e.g., T-shape)
			var connections := []
			for i in range(4):
				if i != (rotation_index + 2) % 4:  # skip the opposite direction
					connections.append((rotation_index + i) % 4)
			return connections
		"Cross":
			return [0, 1, 2, 3]
		_:
			return []

## Sets the pipe slot to a specific pipe type.
func set_pipe(pipe_type: String, rotation_index: int):
	self.pipe_type = pipe_type
	self.rotation_index = rotation_index
	update_pipe_texture()
	pipe_display.rotation_degrees = rotation_index * 90

## Clears the pipe of that slot.
func clear_pipe():
	self.pipe_type = ""
	self.rotation_index = 0
	pipe_display.texture = null


# Pipe Power Highlight
## Highlight the pipes that are connected to power.
func highlight():
	is_powered = true
	modulate = Color(1, 1, 1)
	pipe_display.modulate = Color(1, 0.8, 0.4) 

## Remove the highlights of pipes that are not/no longer connected to power.
func clear_highlight():
	is_powered = false
	modulate = Color(1, 1, 1)
	pipe_display.modulate = Color(1, 1, 1)
