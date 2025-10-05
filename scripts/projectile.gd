extends Area2D
## Projectiles used by the Daisy Monsters.
##
## Projectiles will be shot at the player with their directions updated in the Daisy Monster script.
##
## Projectiles will be removed from the scene after a 4 second timer.

@export var speed: float = 60 ## Constant speed of the projectiles
var direction: Vector2 ## Directional vector for the projectile

## Update the position of the projectiles.
func _process(delta):
	position += direction.normalized() * speed * delta

## Remove the projectiles on timeout.
func _on_projectile_timer_timeout() -> void:
	queue_free()
