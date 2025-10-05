extends Node2D
## Opening scene of the game. 
## 
## Has a set of timers that control what is displayed on the screen.

@onready var player = $ThePlayer ## Get player node for accessing the script
@onready var fade = $Fade ## Get ColorRect node for fading

var duration = 2 ## Tween duration
var tween: Tween = null ## Set tween to null to not mess with other tweens.

## Play the car animation.
## Display initial message and adjust the display time accordingly.
func _ready() -> void:
	$Car/CarSprite.play("default")
	player.narration_box.display_time = 4.75
	player.show_message("You have been dispatched by \nthe Eidos Institute to the Grisham Estate.")

## Change the car animation to idle and remove the headlight node from the car.
## Set the player node to visible and display the next message.
## Start the "StartTimer."
func _on_car_timer_timeout() -> void:
	$Car/CarSprite.play("idle")
	$Car/Headlights.queue_free()
	$PlayerNode.visible = true
	player.show_message("Your task: uncover what happened and \nbring back any records they left behind.")
	$StartTimer.start()

## Display the next message and adjust the display time accordingly
func _on_message_timer_timeout() -> void:
	player.narration_box.display_time = 3.75
	player.show_message("The scientists stationed there have \ngone silent, their whereabouts unknown.")

## Fade out
func _on_start_timer_timeout() -> void:
	await fade_out(fade)

## Set target visibility to true and target modulate.a to 0.0. 
## Create the tween and adjust the tween property to (target, modulate.a, 0.0, duration).
## The 0.0 will have the ColorRect go from opaque to transparent.
## Await tween.
## Load the outside_front scene on tween completion.
func fade_out(target: ColorRect) -> void:
	target.visible = true
	target.modulate.a = 0.0
	
	tween = create_tween()
	tween.tween_property(target, "modulate:a", 1.0, duration) # 0 → 1 (fade to black)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/floors/outside_front.tscn")
