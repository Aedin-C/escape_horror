extends Node2D
## Runs the ending of the game.
## Uses several timers to smoothly change the display.

@onready var player_cam = $Player/Camera2D ## Camera focused on the player
@onready var zoom_cam1 = $Zoomed ## Full scene cam
@onready var player = $ThePlayer ## Get the player node to call on functions
@onready var rect = $ColorRect ## Get the ColorRect node to call on for fading
@onready var rect2 = $ColorRect2 ## Get the other ColorRect node to call on for fading

var duration = 2 ## Fade duration
var tween: Tween = null ## Set tween to null to affect other tweens

## Initial message when the scene begins, also adjust display time accordingly.
func _ready() -> void:
	player.narration_box.display_time = 2.5
	player.show_message("The monsters caught up to you \nand dragged your body back.")

## When the drag animation has ended, display another message and change the time accordingly.
## Remove the player camera to have a zoomed out look.
## Start the zoom timer.
func _on_drag_timer_timeout() -> void:
	player.narration_box.display_time = 2
	player.show_message("And now here is where you lay.")
	if not player_cam == null:
		$Player/Camera2D.queue_free()
	zoom_cam1.visible = true
	$ZoomTimer.start()

## Fade in the first ColorRect.
## Remove the backyard camera and replace it with a secondary camera for more zoom
## and different visuals.
## Display another message and start the dark timer.
func _on_zoom_timer_timeout() -> void:
	await fade_in(rect)
	remove_child(zoom_cam1)
	$Zoomed3.visible = true
	player.show_message("Forever in the backyard.")
	$DarkTimer.start()

## Fade out the second ColorRect.
## Display the final message and adjust the display time to last the remainder of the scene.
## Start the menu timer.
func _on_dark_timer_timeout() -> void:
	await fade_out(rect2)
	player.narration_box.display_time = 6
	player.show_message("You can hear a faint whisper \ncoming from the dirt below you.\nPerhaps you too are becoming one of them...")
	$MenuTimer.start()

## Fade in the second ColorRect.
## Return to menu upon completion.
func _on_menu_timer_timeout() -> void:
	await fade_in(rect2)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

## Make the ColorRect visible and set the modulate.a to transparent (0.0) for fading in.
## Create the tween and adjust the tween property to (target, modulate.a, 1.0, duration).
## The 1.0 will have the ColorRect go from transparent to opaque. 
## Await tween.
func fade_in(target: ColorRect) -> void:
	target.visible = true
	target.modulate.a = 0.0
	tween = create_tween()
	tween.tween_property(target, "modulate:a", 1.0, duration)
	await tween.finished

## Create the tween and adjust the tween property to (target, modulate.a, 0.0, duration).
## The 0.0 will have the ColorRect go from opaque to transparent.
## Await tween.
func fade_out(target: ColorRect) -> void:
	tween = create_tween()
	tween.tween_property(target, "modulate:a", 0.0, duration)
	await tween.finished
