extends Control
## Pause menu scene that allows the player to resume the game or exit to the main menu.
##
## Menu is opened when the player presses escape and closes when the player pressed escape or the resume key.
##
## Game will be fully paused when the menu is open.

var is_open = false ## Boolean that changes if the menu is open

## Close the menu by default.
func _ready() -> void:
	close()

## Open/close the inventory when the escape key is pressed.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		if get_node("../").puzzle_active:
			return
		if is_open:
			close()
		else:
			open()

## Unpause the game by calling close().
func _on_resume_pressed() -> void:
	close()

## Return to menu by loading the menu scene.
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

## Open the menu by setting visiblity to true, is_open to true, and paused to true.
func open():
	visible = true
	is_open = true
	get_tree().paused = true

## Close the menu by setting visiblity to false, is_open to false, and paused to false.
func close():
	visible = false
	is_open = false
	get_tree().paused = false
