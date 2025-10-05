extends Area2D 
## Crates will store an item which can be collected by the player.
##
## Crates use CrateInv to hold a single item in their inventory.
##
## UI will be opened when player right clicks within the area's hitbox.
##
## When the player dies, crates are reset to their intial state. 

var entered = false ## Body entered by player

@onready var crate_ui = $CrateInvUI ## Call on the CrateInvUI node to access the script.

@export var inv: CrateInv ## Crates use a CrateInv object to hold items
@export var crate_id: String = "" ## Crate ID string to store information

var player = null ## Set player to null so it can be updated in the future. 

## Add all crates to a group to ensure crate information is stored between scenes.
## Load the data and update the slot of the crate's inventory.
func _ready():
	add_to_group("crates")

	var saved_data = SaveManager.load_crate(crate_id) 
	if saved_data.size() > 0: 
		for i in range(min(inv.slots.size(), saved_data.size())): 
			inv.slots[i].item = saved_data[i]
		crate_ui.update_slots()

## Open the crate ui when the player has entered the body.
func _physics_process(delta: float): 
	if entered and Input.is_action_pressed("right_click"): 
		if !crate_ui.is_open: 
			crate_ui.open() 

## Reset the crate inventories.
## Load the data and update the slot of the crate's inventory.
func reset_inventory():
	var saved_data = SaveManager.load_crate(crate_id)
	for i in range(inv.slots.size()):
		if i < saved_data.size():
			inv.slots[i].item = saved_data[i]
	crate_ui.update_slots()

func _on_crate_body_entered(body: CharacterBody2D) -> void: 
	entered = true 
	player = body 
	crate_ui.player = body 
	
func _on_crate_body_exited(body: CharacterBody2D) -> void: 
	entered = false
