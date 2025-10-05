extends Node2D
## Crawling monster that moves based on colliding with walls in front of it. 
##
## Turns to the 90 degrees CW when it collides. 

const SPEED = 50 ## Default speed of the crawler

@onready var ray_casts = [
	$Horizontal/RayCastH,  ## Horizontal Raycast
	$Vertical/RayCastV,    ## Vertical Raycast
]
@onready var h_sprite = $Horizontal/HSprite ## Horizontal Sprite
@onready var v_sprite = $Vertical/VSprite ## Vertical Sprite
@onready var hori = $Horizontal ## Horizontal Node
@onready var verti = $Vertical ## Veritcal Node

@onready var collision_h = $Horizontal/Killzone/CollisionH ## Horizontal Collision shape
@onready var collision_v = $Vertical/Killzone/CollisionV ## Vertical Collision shape

var directions = [
	Vector2(-1, 0),  ## left
	Vector2(0, -1),  ## up
	Vector2(1, 0),   ## right
	Vector2(0, 1)    ## down
]

var current_dir_index = 0 ## Current direction

## Update the direction on load.
func _ready():
	update_direction()

## Update the direction the crawler is facing and the position of the crawler.
func _process(delta: float) -> void:
	var ray = get_current_raycast()
	if ray.is_colliding():
		current_dir_index = (current_dir_index + 1) % 4
		update_direction()

	position += directions[current_dir_index] * SPEED * delta

## Update the rotation and flip of the sprite and raycast as well as the animations.
func update_direction():
	var dir = directions[current_dir_index]

	## Horizontal movement
	if dir.y == 0:
		hori.visible = true
		verti.visible = false
		ray_casts[0].enabled = true
		ray_casts[1].enabled = false
		collision_h.disabled = false
		collision_v.disabled = true

		h_sprite.flip_h = (dir.x > 0)
		ray_casts[0].target_position = Vector2(24 * dir.x, 0)

	## Vertical movement
	elif dir.x == 0:
		hori.visible = false
		verti.visible = true
		ray_casts[0].enabled = false
		ray_casts[1].enabled = true
		collision_h.disabled = true
		collision_v.disabled = false

		v_sprite.flip_v = (dir.y > 0)
		ray_casts[1].target_position = Vector2(0, 26 * dir.y)

	ray_casts[0].force_raycast_update()
	ray_casts[1].force_raycast_update()

## Determines which raycast is active based on the direction of movement.
func get_current_raycast() -> RayCast2D:
	return ray_casts[0] if directions[current_dir_index].y == 0 else ray_casts[1]
