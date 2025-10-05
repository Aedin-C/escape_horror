extends Node2D
## Runs the secret ending of the game.
## Uses timers to smoothly change the display.

@onready var fade = $Fade ## Get the ColorRect node for fading
@onready var player = $ThePlayer ## Get the player node to access the script

var duration = 5 ## Fade duration
var tween: Tween = null ## Set tween to null to affect other tweens

## Display the initial message, adjust the display time accordingly.
func _ready() -> void:
	player.narration_box.display_time = 3.5
	player.show_message("You’ve escaped the estate \nand found a getaway car.")

## Remove the player node, set the car's headlight node visibility to true, start
## the car animation and car timer, and display another message.
func _on_animation_timer_timeout() -> void:
	$PlayerNode.queue_free()
	$Car/Headlights.visible = true
	$Car/CarSprite.play("default")
	$CarTimer.start()
	player.show_message("You reported your success to \nthe company, along with the \ntragic fate of the scientists.")

## Display the final message and fade in.
func _on_car_timer_timeout() -> void:
	player.show_message("For now, your mission is complete. \nAs you drive off, you wonder what \nwill become of that place.")
	await fade_in(fade)

## Make the ColorRect visible and set the modulate.a to transparent (0.0) for fading in.
## Create the tween and adjust the tween property to (target, modulate.a, 1.0, duration).
## The 1.0 will have the ColorRect go from transparent to opaque. 
## Await tween and upon tween completion, load the main menu scene.
func fade_in(target: ColorRect) -> void:
	target.visible = true
	target.modulate.a = 0.0
	tween = create_tween()
	tween.tween_property(target, "modulate:a", 1.0, duration)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
