extends Control
## Controls the keypad used to open the vault door. 
##
## A code is set for the door and when the player enteres the code using 
## the keypad, a variable for the state of the code will be changed
## allowing the door to pass the "locked" check. 
##
## The keypad consists of 12 buttons, 1 button for each of the numbers
## 0-9, a clear button, and a check button. 

@export var correct_code: String = "721380" ## Vault code
var entered_code: String = "" ## Code entered by player

@onready var display_label: Label = $Panel/VBoxContainer/Label ## Label to display the code
@onready var grid: GridContainer = $Panel/VBoxContainer/GridContainer ## Hold the keypad buttons
@onready var close_button: Button = $Panel/Close ## Close button
@onready var player = get_parent() ## Get the player node to access the script

## Ensure that the game remains paused when UI is open.
## Load buttons and connect the close_button.
func _ready():
	process_mode = 2
	
	for child in grid.get_children():
		if child is Button:
			child.pressed.connect(func(): _on_button_pressed(child.text))
	
	close_button.pressed.connect(func(): 
		get_tree().paused = false
		player.close_keypad()
	)

## Implement the buttons. "✓" button checks code, "c" button clears the code, and numbered buttons
## enters their respective number. 
func _on_button_pressed(text: String):
	match text:
		"✓":
			_check_code()
		"c":
			entered_code = ""
			display_label.text = ""
		_:
			if entered_code.length() < 6:
				entered_code += text
				display_label.text = entered_code

## Check the code; if the entered_code matches the correct_code, close the keypad and alert the
## player that the code was correct and the door has unlocked. 
## If the codes don't match, reset the code to empty.
func _check_code():
	if entered_code == correct_code:
		PipeCompletion.keypad_complete = true
		get_tree().paused = false
		player.close_keypad()
		player.show_message("The code went through! The door unlocked.")
	else:
		entered_code = ""
		display_label.text = ""
