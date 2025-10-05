extends Control
## Controls the UI of the player's inventory.
##
## Allows the player to open the UI and displays the pages of their inventory.
## 
## Player can interact with the items in the slots to view their name and description.

@onready var slots: Array = $NinePatchRect/GridContainer.get_children() ## Access the slot nodes

@onready var inv: Inv = GameManager.temp_inv ## Access to the player's inventory

@onready var item_name: Label = $NinePatchRect/VBoxContainer/ItemName ## Access to the names of the items
@onready var item_desc: RichTextLabel = $NinePatchRect/VBoxContainer/ItemDescription ## Access to the description of the items
@onready var desc_arrow: Label = $NinePatchRect/VBoxContainer/ItemDescription/ArrowIndicator ## Access to the description arrow node

var is_open: bool = false ## Inventory UI is closed by default
var desc_pages: Array[String] = [] ## Array for the pages that an item's description takes.
var current_page = 0 ## Current page of the inventory
var current_page_index = 0 ## Current index of the page

## Connect the UI to the inventory logic.
func _ready():
	if inv:
		inv.update.connect(update_slots)
	
	for slot_node in slots:
		slot_node.clicked.connect(_on_slot_clicked)

	item_desc.gui_input.connect(_on_description_box_clicked)
	update_slots()
	close()

## Update the slots of the inventory by inserting an item into the inventory.
func update_slots():
	if inv:
		inv.ensure_first_page()
		current_page_index = clamp(current_page_index, 0, inv.pages.size() - 1)

		var page = inv.pages[current_page_index]
		for i in range(slots.size()):
			if i < page.size():
				slots[i].update(page[i])
			else:
				slots[i].update(null)

## When an item slot is clicked, display the item's name and description.
func _on_slot_clicked(slot: InvSlot):
	if slot.item:
		item_name.text = slot.item.name
		desc_pages = paginate_text_by_lines(slot.item.description.replace("\\n", "\n"), 1)
		
		## Description debugging
		#print("Full description:\n", slot.item.description)
		#print("Desc pages:", desc_pages.size())
		#for i in desc_pages:
			#print("---\n", i)
		
		current_page = 0
		update_description_page()
	else:
		item_name.text = ""
		item_desc.text = ""
		current_page = 0
		desc_arrow.visible = false

## Player input for opening/closing the inventory. 
## If the puzzle UI is active, don't open the inventory.
func _input(event):
	if event.is_action_pressed("e"):
		if get_node("../").puzzle_active:
			return
		if is_open:
			close()
		else:
			open()

## Open the UI and pause the game.
func open():
	visible = true
	is_open = true
	get_tree().paused = true

## Close the UI and unpause the game.
func close():
	visible = false
	is_open = false
	get_tree().paused = false
	item_name.text = ""
	item_desc.text = ""

## Send the item description into different pages using '\n' as a separater.
func paginate_text_by_lines(text: String, lines_per_page: int = 1) -> Array[String]:
	var lines = text.split("\n", false)
	var pages: Array[String] = []
	var current = ""
	var count = 0
	
	for line in lines:
		current += line + "\n"
		count += 1
		if count >= lines_per_page:
			pages.append(current.strip_edges())
			current = ""
			count = 0
	
	if current.strip_edges() != "":
		pages.append(current.strip_edges())
	
	return pages

## Load the next desciption page. If there's another page after the current one, 
## display the description arrow again. If the description is completed (no more pages),
## then there isn't more to display.
func update_description_page():
	if desc_pages.is_empty():
		item_desc.text = ""
		desc_arrow.visible = false
		return
	
	item_desc.text = desc_pages[current_page]
	desc_arrow.visible = current_page < desc_pages.size() - 1

## If there's another page of the item's description,
## load and display the next page.
func _on_description_box_clicked(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if current_page < desc_pages.size() - 1:
			current_page += 1
			update_description_page()

## Load and display the next page of the inventory.
func next_page():
	if current_page_index < inv.pages.size() - 1:
		current_page_index += 1
		update_slots()

## Load and display the previous page of the inventory
func prev_page():
	if current_page_index > 0:
		current_page_index -= 1
		update_slots()
