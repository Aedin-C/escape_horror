extends Resource
## Creates the resource used for the crate inventory to store and hold items.

class_name CrateInv

@export var slots: Array[InvSlot] ## Uses an array of inventory slots, similar to the player inventory.

signal update ## Signal to the UI that there is an update

## Insert an item into the crate inventory.
## Used for when the player dies and item isn't saved in their inventory.
func insert(item: InvItem): 
	var itemslots = slots.filter(func(slot): return slot.item == item) 
	if itemslots.is_empty(): 
		var emptyslots = slots.filter(func(slot): return slot.item == null) 
		if !emptyslots.is_empty(): 
			emptyslots[0].item = item 
	update.emit()
