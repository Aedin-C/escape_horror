extends Node2D
## Tile puzzle is a 3x3 area of tiles that the player steps on and interacts with to change
## the colour of. 
##
## Check the arrangement of tiles to see if all tiles are selected and remove the lasers 
## from the scene upon completion. 

@onready var tiles: Array = $".".get_children() ## Get the tile nodes to access their scripts
@onready var lasers = $"../Lasers" ## Get the laser node for removal
@onready var player = $"../Player" ## Get the player node to access the script

## Check if all the tiles are selected.
func check_solution():
	for tile in tiles:
		if not tile.is_selected:
			return
	puzzle_solved()

## Inform the player to check the lasers and remove the lasers.
func puzzle_solved():
	player.show_message("Something in the air shifted. \nYou should check on the lasers.")
	JournalManager.update_task("Dance Floor", "Something in the air shifted. You should check on the laser.")
	if lasers:
		lasers.queue_free()
