extends Panel
## Controls the information and visuals of a slot of the inventory.
##
## A slot contains a visual of the item, which can be collected by the player.
## When left clicked, the item will be collected by the player.

signal clicked(slot: InvSlot) ## Signal for when the slot is clicked
@onready var item_visual = $CenterContainer/Panel/Item_Display ## Get the Item_Display node to change visuals.

var slot: InvSlot = null ## Set the slot to null to ensure it isn't affect by other slots

## Update the slot's visuals.
## Check if the slot exists and has an item and change visual parameters accordingly.
func update(new_slot: InvSlot):
	slot = new_slot
	if !slot or !slot.item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture

## Check for left mouse button input and emi the signal.
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if slot != null and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(slot)
