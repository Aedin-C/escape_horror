extends Node
## Manages the save state of the crates. 
##
## If the player dies, all items they collected on that scene will return to their respective crates.
##
## If the player leaves the scene successfully, all updated crates will remain empty.
##
## All unaffected crates remain as is.
##
## Ensures crates with the same ID share the same inventory updates.

var crate_data: Dictionary = {} ## Permanent crate state

var crate_temp_data: Dictionary = {} ## Temporary crate state

## Save the information for crates with the same ID.
## Call serialize from the InvSlot and ensure item IDs apply to their respective crate IDs.
func save_crate(crate_id: String, slots: Array, is_temp: bool = true):
	var items = []
	for slot in slots:
		items.append(slot.item)
	if is_temp:
		crate_temp_data[crate_id] = items
	else:
		crate_data[crate_id] = items
	
	#print("Saved slots for ", crate_id, " (temp=", is_temp, "): ", items) ## Used for testing if crates were saved

## Load items into the crates.
## Check if temp data exists, otherwise load the permanent data.
## Temp data represents the data for the floor (use temporary saves so that items
## are reloaded when the player dies).
## Permanent data is used for when the player leaves the scene
func load_crate(crate_id: String) -> Array:
	if crate_temp_data.has(crate_id):
		return crate_temp_data[crate_id]
	elif crate_data.has(crate_id):
		return crate_data[crate_id]
	return []

## Clear the temporary data when the player dies
func reset_temp_crates():
	crate_temp_data.clear()

## When the player leaves the scene, ensure crates remain empty.
## Set crate data to the temp data (empty).
func promote_temp_to_permanent():
	for crate_id in crate_temp_data.keys():
		crate_data[crate_id] = crate_temp_data[crate_id]
