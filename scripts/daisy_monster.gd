extends Node2D
## Allows the flower monsters to shoot at the player.
## 
## Projectiles are spawned on the monster and travel in a straight line in the
## direction of the player based on their position when it is shot. 

@export var projectile_scene: PackedScene ## Projectiles

@onready var monster_timer = $Timer ## Cooldown for shooting
@onready var player = get_node("../../Player") ## Get the player node to access position

## Checks for the player node. Shoots projectiles based on the position of the player
## when the projectile is instantiated. 
func shoot():
	if not is_instance_valid(player):
		return

	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.direction = player.global_position - global_position
	get_tree().current_scene.add_child(projectile)

## Shoot when cooldown is done
func _on_monster_timer_timeout() -> void:
	shoot()
