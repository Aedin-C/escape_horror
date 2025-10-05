extends Control
## The UI for the crates will display an inventory slot when clicked upon.
##
## If there is an item inside the crate, that item will be displayed to the player
## and can be collected.
##
## Update the crate inventory to reflect changes made.

@onready var crate = get_parent() ## Access the Crate node for access to the script
@onready var inv: CrateInv = crate.inv ## Inventory used for the crate
@onready var slots: Array = $NinePatchRect/GridContainer.get_children() ## Array of slots for the inventory

var is_open = false ## Boolean for determining if the UI is open.
var player = null ## Player node set to null for updating when player enters body.

## Connect the ability to click on the slot so that players can collect the items.
## Update the slots of the crate on load.
## Ensure the UI is closed by default.
func _ready():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].connect("clicked", Callable(self, "_on_slot_clicked"))
	update_slots()
	close()

## Update the inventory slots of the crate.
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

## Make the UI visible and set open to true
func open():
	visible = true
	is_open = true

## Make the UI invisible and set open to false
func close():
	visible = false
	is_open = false

## Collect the item when the slot is clicked on.
## Item will be added to the player's inventory and removed from the crate's inventory.
## Inform the player on the item name.
## Update crate slots and save the crate.
func _on_slot_clicked(slot: InvSlot):
	if slot != null and slot.item != null and player != null:
		player.collect(slot.item)
		player.show_message("You collected " + slot.item.name + ".")
		slot.item = null
		update_slots()
		SaveManager.save_crate(crate.crate_id, crate.inv.slots)
