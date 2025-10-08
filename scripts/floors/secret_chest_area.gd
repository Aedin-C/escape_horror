extends Area2D
## Area body for the player open a secret crate.
##
## When entered, if the player has the Secret Key, they can right click to access the crate.

@onready var highlight = $Highlight ## Access to the highlight node
@onready var player = $"../../Player" ## Get the player node to call on functions
var se_key = "Secret Key" ## Name of the key we want to check for

var entered = false ## Body entered by player

## Set the highlight visibility to false
func _ready() -> void:
	highlight.visible = false

func _on_secret_chest_area_body_entered(body: CharacterBody2D) -> void:
	entered = true
	highlight.visible = true

func _on_secret_chest_area_body_exited(body: CharacterBody2D) -> void:
	entered = false
	highlight.visible = false

func _physics_process(delta: float) -> void:
	if entered and (Input.is_action_just_pressed("right_click") or Input.is_action_just_pressed("left_click")):
		player.show_message("It's a metallic chest. \n It looks like there's a \nspecial keyhole in it...")
		JournalManager.add_task("Chest", "There's a metallic chest on the main floor. Seems like it needs a key.")
		if check_key():
			$"../../Crates/Crate5".visible = true

## Checks the player's inventory for the required key to open the crate.
## Loops through the inventory until it finds an item named "Secret Key."
## If item is found, the player can access the crate.
func check_key() -> bool:
	var items = player.get_inv()
	for item in items:
		if item == se_key:
			JournalManager.update_task("Chest", "Secret Key was used!")
			return true
	return false
