extends CanvasLayer
## Displays messages to the player for a period of time, fades out afterwards using a tween.

@onready var box = $NinePatchRect ## Get the NinePatchRect node for fading
@onready var label = $NinePatchRect/Label ## Get the Label node to update the message

var display_time = 1 ## Display time of messages
var tween: Tween = null ## Set the tween to null

## Update the Label node and display the message to the player.
## Remove any running tweens (in case there's an existing message fading out, override).
## Create a timer for the display time and fade out.
func show_message(text: String):
	box.modulate.a = 1.0
	label.text = text
	visible = true
	if tween:
		tween.kill()
	await get_tree().create_timer(display_time).timeout
	fade_out()

## Create the tween and adjust the tween property to (target, modulate.a, 0.0, 1.0).
## The 0.0 will have the ColorRect go from opaque to transparent.
## 1.0 is the duration of the fade, 1 second.
## Await tween and make the visibility false.
func fade_out():
	tween = create_tween()
	tween.tween_property(box, "modulate:a", 0.0, 1.0)
	await tween.finished
	visible = false
