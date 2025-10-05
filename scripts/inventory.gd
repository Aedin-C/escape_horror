extends Resource
## Controls the player's inventory. 
##
## Inventory contains multiple pages of item slots and adds pages as they fill up.

class_name Inv ## Sets the class name for creating objects

signal update ## Signals that the inventory was updated

@export var slots_per_page = 12 ## Number of inventory slots per page
@export var pages: Array[Array] = [] ## Array of pages that holds slots

## Create the initial page.
func _init():
	if pages.is_empty():
		_add_page()

## Add a page to the end of the array, a page holds an array of inventory slots.
func _add_page():
	var new_page: Array[InvSlot] = []
	for i in range(slots_per_page):
		var slot := InvSlot.new()
		slot.item = null
		new_page.append(slot)
	pages.append(new_page)

## Checks that items are being added to the initial page first.
func ensure_first_page():
	if pages.is_empty() or pages[0].is_empty():
		_add_page()

## Insert an item into the inventory.
func insert(item: InvItem):
	ensure_first_page()
	
	# Try stacking (in case of bug)
	for page in pages:
		for slot in page:
			if slot.item == item:
				return
	
	# Find empty slot
	for page in pages:
		for slot in page:
			if slot.item == null:
				slot.item = item
				update.emit()
				return

	# Add new page if no empty slots
	_add_page()
	pages[-1][0].item = item
	update.emit()

## Get a specific item from the inventory. Returns the item slot name.
func get_item() -> Array:
	var result: Array = []
	for page in pages:
		for slot in page:
			if slot.item:
				result.append(slot.item.name)
	return result

## Clears the inventory.
func clear():
	for page in pages:
		for slot in page:
			slot.item = null
	update.emit()

## Creates a duplicate state of the inventory by copying all current items
## to another inventory. 
func duplicate_from(other: Inv):
	pages.clear()
	for page in other.pages:
		var new_page: Array[InvSlot] = []
		for slot in page:
			var new_slot := InvSlot.new()
			# Make sure items don't point to the same reference
			if slot.item != null:
				new_slot.item = slot.item.duplicate() if slot.item.has_method("duplicate") else slot.item
			else:
				new_slot.item = null
			new_page.append(new_slot)
		pages.append(new_page)
	update.emit()
