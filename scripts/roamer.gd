extends Node2D
## Roaming monster that moves based on a navigation region.
##
## Will walk around aimlessly until the player is within a certain distance.

@export var speed: float = 70 ## Base speed for the monster
@export var detection_range: float = 200 ## Range for detecting the player
@export var player_path_threshold: float = 25  ## Distance threshold to detect if path to player is "direct"

@onready var player = get_node("../../Player") ## Get the player node to access the script
@onready var sprite = $AnimatedSprite2D ## Get the monster's sprite node for changing animations
@onready var nav_agent = $NavigationAgent2D ## Get the monster's navigation agent for navigating through regions

enum State { ROAM, CHASE } ## Set states for roaming and chasing
var state = State.ROAM ## Set default state to roam
var direction = Vector2.ZERO ## Direction the monster faces/moves in
var roam_target = Vector2.ZERO ## Location the monster roams towards 

## Setup randomization for roaming and add roaming monsters to a group.
## Setup the signal for when the player is in a locker.
func _ready():
	randomize()
	add_to_group("Roamers")
	if player.has_signal("hiding_changed"):
		player.connect("hiding_changed", Callable(self, "_on_player_hiding_changed"))

## Calculates the distance from the player to determine which movement state
## the roamer is in (roam or chase). 
func _physics_process(delta):
	if not is_instance_valid(player):
		return
	var distance_to_player = global_position.distance_to(player.global_position)
	match state:
		State.ROAM:
			_roam(delta)
			if not player.is_hidden and distance_to_player < detection_range and _can_see_player():
				state = State.CHASE
		State.CHASE:
			if player.is_hidden or distance_to_player > detection_range or not _can_see_player():
				state = State.ROAM
			else:
				_chase_player(delta)
	_update_animation()

## Controls the location that the monster roams to by taking its current position
## and adding a randomized vector for its destination target.
func _roam(delta):
	if global_position.distance_to(roam_target) < 10 or nav_agent.is_navigation_finished():
		roam_target = global_position + Vector2(randf() * 400 - 200, randf() * 400 - 200)
		nav_agent.target_position = roam_target
	_move_towards_target(delta)

## Controls the targeting for when the player is within the detection range and
## path threshold. Sets the destination target as the player's location.
func _chase_player(delta):
	nav_agent.target_position = player.global_position
	_move_towards_target(delta)

## Controls the movement of the monster using its position, speed, and the delta variable.
func _move_towards_target(delta):
	if nav_agent.is_navigation_finished():
		return
	var next_position = nav_agent.get_next_path_position()
	direction = (next_position - global_position).normalized()
	global_position += direction * speed * delta

## Determines if the monster can see the player using a navigation map. 
## If the path to the player is too long or winding, assume the player is not 
## directly visible.
func _can_see_player() -> bool:
	var nav_map = nav_agent.get_navigation_map()
	var path = NavigationServer2D.map_get_path(
		nav_map,
		global_position,
		player.global_position,
		false
	)
	if path.size() < 2:
		return false
	var total_path_length = 0.0
	for i in range(path.size() - 1):
		total_path_length += path[i].distance_to(path[i + 1])
	return total_path_length - global_position.distance_to(player.global_position) < player_path_threshold

## Updates the animation of the monster based on if its walking or idling.
func _update_animation():
	if direction.length() > 0:
		sprite.play("walk")
		sprite.flip_h = direction.x < 0
	else:
		sprite.play("idle")

## If the monster is chasing the player and the player is hiding, set the state to roam.
func _on_player_hiding_changed(hidden: bool):
	if hidden and state == State.CHASE:
		state = State.ROAM
