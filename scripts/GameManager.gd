extends Node
## Controls the save state of the player's inventory and the scene the player is currently on.
##
## Create two inventories, one which will be updated whenever the player leaves the scene (permanent)
## and one which will be updated during each scene (temporary). 
##
## The temporary inventory will be reset to the permanent inventory every time the player dies. 
## The permanent inventory is updated using the temporary inventory whenever a player 
## successfully makes it to the next scene.

var main_inv: Inv ## Permanent inventory
var temp_inv: Inv ## Temporary inventory
var current_scene = "" ## Current scene path

## Load the permanent inventory and create a duplicate to save as the temporary inventory.
func _ready() -> void:
	main_inv = preload("res://assets/inventory/player_inventory.tres")
	temp_inv = Inv.new()
	temp_inv.duplicate_from(main_inv)

## Create the temporary inventory by copying the main inventory.
func enter_scene() -> void:
	temp_inv.duplicate_from(main_inv)

## Update the permanent inventory by copying the temporary inventory.
func leave_scene() -> void:
	main_inv.duplicate_from(temp_inv)

## Set the scene path.
func set_scene(scene: String):
	current_scene = scene
