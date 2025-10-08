extends Node2D
## Determines if the sink monster (blinky) spawns.
## Blinky screams for the roaming monster to come and attack you.

@export var spawn_chance := 0.1 ## Base spawn chance

@onready var monster_sprite = $AnimatedSprite2D ## Animated sprite for the monster
@onready var collision = $Area2D/CollisionShape2D ## Collision shape to activate scream
@onready var scream = $Scream ## Sound for the scream
@onready var roamer = $"../Roamer" ## Get the roamer to access the script
@onready var timer = $Timer ## Timer for how long roamer gets super-agro'd
@onready var screamTimer = $ScreamTimer ## Timer for how long the blinky can't scream for

var hasScreamed = false ## Variable for if the monster has screamed

## Determines if the sink monster spawns using randomize() and checking if that is
## less than the spawn_chance. Sets the visibility and disabling of the node accordingly.
func _ready():
	randomize()
	if randf() < spawn_chance:
		monster_sprite.visible = true
		collision.disabled = false
	else:
		monster_sprite.visible = false
		collision.disabled = true

## When the player enters the collision body of the 
## Blinky, scream and have the roamer come.
func on_blinky_body_entered(body: CharacterBody2D) -> void:
	if !hasScreamed:
		scream.play()
		roamer.detection_range += 1000
		roamer.player_path_threshold += 1000
		timer.start()
		hasScreamed = true

## Set the values of the roamer back to default.
func _on_timer_timeout() -> void:
	roamer.detection_range -= 1000
	roamer.player_path_threshold -= 1000
	screamTimer.start()

## Allow the monster to scream again
func _on_scream_timer_timeout() -> void:
	hasScreamed = false
