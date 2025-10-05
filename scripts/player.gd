extends CharacterBody2D
## Character that is controlled by the player. 
##
## Includes movement and UI/environment interaction logic.

const SPEED = 60 ## Base speed of the player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D ## Access the animated sprite node
@onready var pause = $Pause ## Access to the pause node

var is_dead = false ## Player is alive by default

# Inventory
@onready var invUI = $Inv_UI ## Access to the inventory UI node
@onready var inv = GameManager.temp_inv ## Access to the inventory object


# Heartbeat
@onready var heartbeat = $HeartbeatPlayer ## Access to the heartbeat audio node
@export var heartbeat_min_distance: float = 50 ## Default min distance of the audio
@export var heartbeat_max_distance: float = 300 ## Default max distance of the audio
@export var heartbeat_min_pitch: float = 2 ## Default min pitch of the audio
@export var heartbeat_max_pitch: float = 0.5 ## Default max pitch of the audio

# Locker
var can_hide = false ## Player cannot hide by default
var current_locker: Area2D = null ## Player is not in a locker by default
var is_hidden = false ## Player is not hidden by default
signal hiding_changed(is_hidden: bool) ## Signals when the player is or isn't hidden

# Narration
@onready var narration_box = $NarrationBox ## Access to the narration box node

# Pipe Puzzle UI
@onready var pipe_puzzle = $"Pipe Puzzle" ## Access to the pipe puzzle node
var puzzle_active = false ## Pipe puzzle isn't open by default
var can_open_puzzle = false ## Pipe puzzle cannot be opened by default

# Keypad UI
@onready var keypad = $"Keypad" ## Access to the keypad node
var keypad_active = false ## Keypad isn't opened by default
var can_open_keypad = false ## Keypad cannot be opened by default

# Desk
@onready var desk_ui = $"DeskUI" ## Access to the desk node
var can_open_desk = false ## Desk cannot be opened by default
var desk_active = false ## Desk isn't opened by default

## Adds the player to a group and connects signals to their respective
## functions if their access nodes exist.
func _ready():
	add_to_group("player")
	
	# Locker hiding
	for locker in get_tree().get_nodes_in_group("lockers"):
		locker.connect("player_entered", Callable(self, "_on_locker_player_entered"))
		locker.connect("player_exited", Callable(self, "_on_locker_player_exited"))
	
	# Pipe Puzzle UI
	if(not get_parent().get_node("PipePuzzleArea") == null):
		var pipe_area = get_parent().get_node("PipePuzzleArea")
		pipe_area.connect("puzzle_entered", Callable(self, "_on_puzzle_entered"))
		pipe_area.connect("puzzle_exited", Callable(self, "_on_puzzle_exited"))
	
	# Keypad UI
	if(not get_parent().get_node("KeypadArea") == null):
		var vault_area = get_parent().get_node("KeypadArea")
		vault_area.connect("keypad_area_entered", Callable(self, "_on_keypad_area_entered"))
		vault_area.connect("keypad_area_exited", Callable(self, "_on_keypad_area_exited"))
	
	# Desk UI
	for desk in get_tree().get_nodes_in_group("desks"):
		desk.connect("desk_area_entered", _on_desk_area_entered)
		desk.connect("desk_area_exited", _on_desk_area_exited)

## Controls the movement of the player. If the player is dead, they cannot move.
## Also controls the heartbeat sound given off by the distance of the player relative
## to the roaming monster. The closer the monster gets, the louder the heartbeat gets.
func _physics_process(delta):
	if is_dead:
		return
	
	# Movement:
	# Get the input direction: -1, 0, 1
	var x_direction = Input.get_axis("move_left", "move_right")
	var y_direction = Input.get_axis("move_up", "move_down")
	
	# Flip the Sprite
	if x_direction > 0:
		animated_sprite.flip_h = false
	elif x_direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if x_direction == 0 && y_direction == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
	
	# Apply horizontal movement
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Apply vertical movement
	if y_direction:
		velocity.y = y_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	# Move the character
	move_and_slide()
	
	# Heartbeat sound config:
	var closest_distance = INF
	
	# Get the location of the roamer
	for monster in get_tree().get_nodes_in_group("Roamers"):
		if not is_instance_valid(monster):
			continue
		var dist = global_position.distance_to(monster.global_position)
		if dist < closest_distance:
			closest_distance = dist
	
	# Play heartbeat when roamer gets within the max distance
	if closest_distance < heartbeat_max_distance:
		if not heartbeat.playing:
			heartbeat.play()
		var t = clamp((closest_distance - heartbeat_min_distance) / (heartbeat_max_distance - heartbeat_min_distance), 0, 1)
		heartbeat.pitch_scale = lerp(heartbeat_min_pitch, heartbeat_max_pitch, t)
		heartbeat.volume_db = lerp(10, 0, t)
	else:
		if heartbeat.playing:
			heartbeat.stop()


## Controls the pausing of the game if different UIs are open.
func _process(delta: float) -> void:
	if invUI.is_open or pause.is_open or puzzle_active or keypad_active or desk_active:
		get_tree().paused = true


# Inventory
## Allows the player to collect items by inserting them into the inventory.
func collect(item):
	inv.insert(item)

## Get the inventory of the player.
func get_inv():
	return inv.get_item()


# Death
## Kill the player, set their animation, and open the death UI scene.
func die():
	is_dead = true
	animated_sprite.play("death")
	get_tree().change_scene_to_file("res://scenes/die.tscn")

## Reset inventory and items.
func on_respawn():
	GameManager.enter_scene()
	SaveManager.reset_temp_crates()


## UI-Specific Inputs
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		# Lockers
		if can_hide and current_locker and not is_hidden:
			hide_in_locker()
		elif is_hidden:
			exit_locker()
		
		# Pipe Puzzle
		if can_open_puzzle and not puzzle_active:
			open_puzzle()
		
		# Keypad
		if can_open_keypad and not keypad_active:
			open_keypad()
		
		# Desk
		if can_open_desk and not desk_active:
			open_desk()


# Lockers
## Hide the player inside the locker.
func hide_in_locker():
	var hide_position = current_locker.get_node("HidePosition").global_position
	global_position = hide_position
	is_hidden = true
	emit_signal("hiding_changed", true)

## Exit the locker.
func exit_locker():
	global_position += Vector2(0, 20)
	is_hidden = false
	emit_signal("hiding_changed", false)

## When player is in range of a locker, allow the player to be 
## able to hide inside it.
func _on_locker_player_entered(locker):
	can_hide = true
	current_locker = locker

## When the player is no longer in range of a locker, remove 
## their ability to access that locker.
func _on_locker_player_exited(locker):
	can_hide = false
	current_locker = null


# Narration
## Display text messages to the player.
func show_message(text: String):
	narration_box.show_message(text)


# Pipe Puzzle UI
## Open the puzzle UI.
func open_puzzle():
	pipe_puzzle.visible = true
	puzzle_active = true

## Close the puzzle UI.
func close_puzzle():
	pipe_puzzle.visible = false
	puzzle_active = false

## When the player is in range of the puzzle area, 
## allow the player to open UI.
func _on_puzzle_entered(area):
	can_open_puzzle = true

## When the player is no longer in range of the puzzle
## area, remove their access to the puzzle.
func _on_puzzle_exited(area):
	can_open_puzzle = false


# Keypad UI
## Open the keypad UI.
func open_keypad():
	keypad.visible = true
	keypad_active = true

## Close the keypad UI.
func close_keypad():
	keypad.visible = false
	keypad_active = false

## When the player is in range of the keypad area,
## allow the player to open UI.
func _on_keypad_area_entered(area):
	can_open_keypad = true

## When the player is no longer in range of the
## keypad area, remove their access to the keypad.
func _on_keypad_area_exited(area):
	can_open_keypad = false


# Desk
## Open the desk UI and add buttons to the desk 
## based on items the player has collected.
func open_desk():
	desk_ui.visible = true
	desk_ui.populate_buttons()
	desk_active = true

## Close the desk UI.
func close_desk():
	desk_ui.visible = false
	desk_active = false

## When the player is in range of a desk area,
## allow the player to open the UI.
func _on_desk_area_entered(area):
	can_open_desk = true

## When the player is no longer in range of a
## desk area, remove their access to the desk.
func _on_desk_area_exited(area):
	can_open_desk = false
