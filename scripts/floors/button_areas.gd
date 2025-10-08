extends Node2D

## Button areas entered variables
var button1_entered = false
var button2_entered = false
var button3_entered = false

## Button pressed variables
var button1 = false
var button2 = false
var button3 = false

var num_pressed = 2 ## Total number of buttons pressed (start at 2 because message is printed before update)
var button_message = "" ## Message displayed when button is pressed

var lasers_disabled = false ## Boolean that determines if the lasers are present

@onready var player = $"../Player" ## Get the player node to access the script
@onready var monster = $"../Monsters/Roamer" ## Get the roamer node to access the script

func _ready() -> void:
	JournalManager.update_task("Find Buttons", "You sense 3 more button(s) can be pressed.")

## Update what button has been pressed, how many buttons remain, and display the message
## for how many buttons are pressed. 
## Increase the roamer's ability to detect the player with each button press.
## When all buttons are pressed, disable the lasers. 
func _physics_process(delta: float) -> void:
	if num_pressed == 0:
		button_message = "Something in the air shifted. \nPerhaps you should check on that laser."
	else:
		button_message = "You sense %d more button(s) can be pressed." % num_pressed
	
	if not (Input.is_action_just_pressed("right_click") or Input.is_action_just_pressed("left_click")):
		return
	
	JournalManager.add_task("Find Buttons", button_message)
	
	var buttons = [
		{"entered": button1_entered, "index": 1},
		{"entered": button2_entered, "index": 2},
		{"entered": button3_entered, "index": 3},
	]
	
	for b in buttons:
		match b["index"]:
			1:
				if b["entered"] and not button1:
					button1 = _handle_button_press()
			2:
				if b["entered"] and not button2:
					button2 = _handle_button_press()
			3:
				if b["entered"] and not button3:
					button3 = _handle_button_press()
	
	if num_pressed == 0 and not lasers_disabled:
		$"../Lasers".queue_free()
		lasers_disabled = true

func _handle_button_press() -> bool:
	monster.detection_range += 10
	monster.player_path_threshold += 5
	num_pressed -= 1
	player.show_message("Click!\n%s" % button_message)
	JournalManager.update_task("Find Buttons", button_message)
	return true

func _on_button_1_body_entered(body: CharacterBody2D) -> void:
	button1_entered = true

func _on_button_1_body_exited(body: CharacterBody2D) -> void:
	button1_entered = false

func _on_button_2_body_entered(body: CharacterBody2D) -> void:
	button2_entered = true

func _on_button_2_body_exited(body: CharacterBody2D) -> void:
	button2_entered = false

func _on_button_3_body_entered(body: CharacterBody2D) -> void:
	button3_entered = true

func _on_button_3_body_exited(body: CharacterBody2D) -> void:
	button3_entered = false
