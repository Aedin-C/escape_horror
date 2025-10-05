extends Node2D
## Controls the logic for the pipe puzzle.
##
## Populates the pipe slots using the predefined layout. 
##
## Checks the pipe puzzle's connections using a BFS through the grid and applies a power
## highlight accordingly.
##
## Checks the pipe solution and sets the global variables accordingly.

const GRID_WIDTH := 7 ## Width of the grid for the puzzle
const GRID_HEIGHT := 6 ## Height of the grid for the puzzle

@onready var grid_container: GridContainer = $NinePatchRect/GridContainer ## Access the grid container of the puzzle
@onready var player = $"../" ## Get the player node to access the script
@export var save_callback: Callable ## Save callback for the pipes

var grid: Array = []  ## 2D array of pipe_slot nodes

## Directions that the pipes face
const DIRS = {
	"up": Vector2i(0, -1),
	"down": Vector2i(0, 1),
	"left": Vector2i(-1, 0),
	"right": Vector2i(1, 0),
}

## Each entry of pipes in the grid = [pipe_type, rotation_index]
var predefined_layout := [
	[["Straight", 2], ["Corner", 1], ["Straight", 3], ["Corner", 3], ["Straight", 1], ["Straight", 3], ["Corner", 3]],
	[["Straight", 0], ["Straight", 0], ["Corner", 2], ["Cross", 1], ["SemiCross", 1], ["Corner", 0], ["Straight", 3]],
	[["SemiCross", 3], ["Straight", 2], ["Corner", 1], ["Corner", 2], ["Straight", 0], ["Corner", 1], ["Corner", 0]],
	[["Straight", 2], ["Straight", 1], ["Corner", 2], ["Cross", 0], ["Corner", 3], ["Straight", 3], ["Corner", 2]],
	[["SemiCross", 2], ["Corner", 0], ["Straight", 1], ["Corner", 0], ["Straight", 3], ["Cross", 3], ["SemiCross", 2]],
	[["Straight", 2], ["Corner", 1], ["SemiCross", 1], ["Straight", 2], ["Straight", 0], ["Corner", 2], ["Straight", 0]],
]

## Set up the puzzle and connect the close button.
func _ready():
	process_mode = 2
	build_grid_reference()
	populate_predefined_pipes()
	$NinePatchRect/CloseButton.pressed.connect(_on_close_button_pressed)

## Build the grid for the puzzle
func build_grid_reference():
	grid.clear()
	var flat_slots := grid_container.get_children()
	if flat_slots.size() != GRID_WIDTH * GRID_HEIGHT:
		push_error("Expected 42 pipe slots, found %d" % flat_slots.size())
		return
	
	# Loop through the height of the grid to add the populated rows to
	for y in range(GRID_HEIGHT):
		var row := []
		# Loop through the width of the grid to add pipes to each slot
		for x in range(GRID_WIDTH):
			var index = y * GRID_WIDTH + x
			var slot = flat_slots[index]
			
			# Connect signal for each slot
			if not slot.is_connected("pipe_rotated", Callable(self, "check_puzzle_solution")):
				slot.connect("pipe_rotated", Callable(self, "check_puzzle_solution"))
			
			row.append(slot)
		grid.append(row)

## Populate the grid with the pipes.
func populate_predefined_pipes():
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			var slot = grid[y][x]
			var cell = predefined_layout[y][x]
			if cell != null:
				slot.set_pipe(cell[0], cell[1])
			else:
				slot.clear_pipe()

## Set up the directions a pipe can face and what connections they affect.
func get_pipe_connections(pipe_type: String, rotation_index: int) -> Array[String]:
	match pipe_type:
		"Straight":
			if rotation_index % 2 == 0:
				return ["left", "right"]
			else:
				return ["up", "down"]
		"Corner":
			match rotation_index % 4:
				0: return ["down", "left"]
				1: return ["left", "up"]
				2: return ["up", "right"]
				3: return ["right", "down"]
		"SemiCross":
			match rotation_index % 4:
				0: return ["up", "right", "left"]   
				1: return ["up", "right", "down"] 
				2: return ["right", "down", "left"]    
				3: return ["down", "left", "up"] 
		"Cross":
			return ["up", "right", "down", "left"]
	
	return [] as Array[String]

## Matches a direction with its opposite.
func get_opposite_direction(dir_name: String) -> String:
	match dir_name:
		"up": return "down"
		"down": return "up"
		"left": return "right"
		"right": return "left"
		_: return ""

## Bounds of the grid puzzle.
func is_in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < GRID_WIDTH and pos.y >= 0 and pos.y < GRID_HEIGHT

## Checks the solution of the puzzle using a coordinate-based system and a bfs tree.
func check_puzzle_solution():
	# Clear all previous highlights
	for row in grid:
		for slot in row:
			slot.clear_highlight()
	
	# Starting position
	var start_pos = Vector2i(0, 2)
	var start_connected_to_edge = false
	var start_slot = grid[start_pos.y][start_pos.x]
	
	# Give power to the initial slot
	if start_slot and start_slot.pipe_type != "" and start_slot.pipe_type != null:
		var start_dirs = get_pipe_connections(start_slot.pipe_type, start_slot.rotation_index)
		for dir_name in start_dirs:
			var offset = DIRS[dir_name]
			var neighbor_pos = start_pos + offset
			if not is_in_bounds(neighbor_pos):
				start_connected_to_edge = true
				break
	
	# Mandatory locations that require power
	var mandatory_outputs: Array[Vector2i] = [
		Vector2i(2, 5),
		Vector2i(4, 0),
		Vector2i(6, 3),
	]
	
	# Optional locations that require power to unlock secret ending
	var optional_outputs: Array[Vector2i] = [
		Vector2i(0, 0),
		Vector2i(0, 5),
		Vector2i(5, 0),
		Vector2i(6, 0),
		Vector2i(6, 5),
	]
	
	var visited = {}
	var queue: Array[Vector2i] = []
	if start_connected_to_edge:
		queue.append(start_pos)
	
	# Arrays for the outputs that have been connected to and powered
	var reached_mandatory: Array[Vector2i] = []
	var reached_optional: Array[Vector2i] = []
	
	# Perform BFS through the pipe grid
	while not queue.is_empty():
		var current = queue.pop_front()
		
		# Skip if already visited
		if current in visited:
			continue
		visited[current] = true
		
		# Get the currnet pipe slot position
		var current_slot = grid[current.y][current.x]
		
		# Skip if the neighbor slot is empty or invalid
		if not current_slot or current_slot.pipe_type == "" or current_slot.pipe_type == null:
			continue
		
		# Apply highlights to connected slots
		current_slot.highlight()
		
		# Determine which directions this pipe connects to (based on type + rotation)
		var current_dirs = get_pipe_connections(current_slot.pipe_type, current_slot.rotation_index)
		
		# If the current position is an output, check if connection reaches out-of-bounds
		if current in mandatory_outputs or current in optional_outputs:
			for dir_name in current_dirs:
				var offset = DIRS[dir_name]
				var neighbor_pos = current + offset
				
				# If the pipe connects off the grid, mark this output as reached
				if not is_in_bounds(neighbor_pos):
					if current in mandatory_outputs and current not in reached_mandatory:
						reached_mandatory.append(current)
					elif current in optional_outputs and current not in reached_optional:
						reached_optional.append(current)
					break
		
		# Continue BFS to connected neighbor pipes
		for dir_name in current_dirs:
			var offset = DIRS[dir_name]
			var neighbor_pos = current + offset
			
			# Ignore neighbors that are outside the grid
			if not is_in_bounds(neighbor_pos):
				continue
			
			var neighbor_slot = grid[neighbor_pos.y][neighbor_pos.x]
			
			# Skip if the neighbor slot is empty or invalid
			if not neighbor_slot or neighbor_slot.pipe_type == "" or neighbor_slot.pipe_type == null:
				continue
			
			# Get neighbor pipe’s valid directions and see if it connects back
			var neighbor_dirs = get_pipe_connections(neighbor_slot.pipe_type, neighbor_slot.rotation_index)
			var opposite_dir = get_opposite_direction(dir_name)
			
			# Only add neighbor if the connection is valid in both directions
			if opposite_dir in neighbor_dirs:
				queue.append(neighbor_pos)
		
		# Check if all placed pipes are powered (visited by BFS)
		var all_pipes_powered = true
		
		for y in range(GRID_HEIGHT):
			for x in range(GRID_WIDTH):
				var pos = Vector2i(x, y)
				var slot = grid[y][x]
				
				# If slot has a pipe but wasn’t visited, then not all are powered
				if slot.pipe_type != "" and slot.pipe_type != null:
					if not visited.has(pos):
						all_pipes_powered = false
						break
		
		# Check puzzle completion conditions
		if start_connected_to_edge and reached_mandatory.size() == mandatory_outputs.size():
			# Main condition: start is connected and all mandatory outputs reached
			PipeCompletion.pipe_complete = true
			
			# Secret condition: all optional outputs and all pipes powered
			if reached_optional.size() == optional_outputs.size() and all_pipes_powered:
				PipeCompletion.secret_pipe_complete = true
			else:
				PipeCompletion.secret_pipe_complete = false
		else:
			# Puzzle not complete if mandatory outputs not satisfied
			PipeCompletion.pipe_complete = false
			PipeCompletion.secret_pipe_complete = false

## Close the UI
func _on_close_button_pressed():
	get_tree().paused = false
	player.close_puzzle() 
