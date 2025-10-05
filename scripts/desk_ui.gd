extends Control
## Controls the UI for the desk. 
##
## The desk is used for displaying items with larger descriptions such as books
## to provide more information.
##
## The player's ability to access different buttons for the information depends on
## what items they have collected.

@onready var button_container: VBoxContainer = $PanelContainer/HBoxContainer/LeftButtonsVBox ## Get the button container node
@onready var info_label: RichTextLabel = $PanelContainer/HBoxContainer/CenterVBox/InfoLabel ## Get the info label node
@onready var page_controls: HBoxContainer = $PanelContainer/HBoxContainer/CenterVBox/PageControls ## Get the page controls node
@onready var prev_button: Button = $PanelContainer/HBoxContainer/CenterVBox/PageControls/PrevButton ## Get the previous button node
@onready var next_button: Button = $PanelContainer/HBoxContainer/CenterVBox/PageControls/NextButton ## Get the next button node
@onready var player = $"../" ## Get the player node to access the script

var current_item_id: String = "" ## Current item is empty by default
var current_page_index: int = 0 ## Current page index is 0 by default

## Page entries for each item
var item_pages := {
	"Owner's Journal": [
		"Entry 1 — March 21, 2025 \n\nI’ve taken possession of the old Grisham estate. Perfectly isolated. The locals speak of strange noises and vanishing livestock, but such things often have mundane causes. I intend to document anything unusual. This is the start of The Arcanum Project.", 
		"Entry 2 — March 26, 2025 \n\nHeard tapping from the kitchen sink last night. Regular intervals, three beats, then silence. Pipes are old — could simply be contraction from the cold. Still, it unnerved my wife.",
		"Entry 3 — April 3, 2025 \n\nThe noise persists. It has spread to the upstairs bathroom. Tonight, I saw movement in the drain. Small, slick, quick.",
		"Entry 4 — April 10, 2025 \n\nCaught it. A creature, dark with glistening yellow eyes. It shrieks when touched. I’ve locked it in Basement Cell 1. Will send word to colleagues for assistance.",
		"Entry 5 — April 19, 2025 \n\nThree fellow scientists have arrived to assist with the study. Specimen remains alive, though its movements slow when deprived of water.",
		"Entry 6 — April 26, 2025 \n\nTragedy. My wife was in the greenhouse tending her roses when one of the flowering vines lashed out. She was gone before I reached her. I buried her by the west fence and sealed the greenhouse with the old iron key. The key now rests where no one will find it.",
		"Entry 7 — May 5, 2025 \n\nDr. Kell has been behaving oddly. He paces at night, muttering to himself, scratching at his arms. Yesterday I found him standing motionless in front of the sink, staring into the drain. I’ve locked him in Cell 2 for observation.",
		"Entry 8 — May 10, 2025 \n\nKell is deteriorating rapidly. He no longer speaks in full sentences. His nails bleed from clawing the bars. Foam gathers at the corners of his mouth. I avoid going near his cell. Thankfully additional help arrived.",
		"Entry 9 — May 13, 2025 \n\nCell 2 is empty. No broken locks, no bent bars. Kell is simply gone.",
		"Entry 10 — May 16, 2025 \n\nScraping sounds from the attic. Heavy, deliberate. My eldest went to investigate… and did not return. I found her later, cold and still, legs torn apart, with her eyes fixated on the floorboards.",
		"Entry 11 — May 20, 2025 \n\nI have sealed the attic door and chained the basement hatch. My last child will be kept safe.",
		"Entry 12 — May 25, 2025 \n\nEvery scientist is now showing the same erratic behavior as Kell. This time, I acted quickly — forcing each of them into a cell. They gnash their teeth when I pass. I fear their strength.",
		"Entry 13 — May 31, 2025 \n\nI am certain now: they will break free. I have gone to the main switch to cut the house’s power. With darkness, perhaps I can flee unseen with my last child.",
		"Entry 14 — June 1, 2025 \n\nToo late. Screams from upstairs. I ran — saw a tall, black figure pulling my child toward the attic. I gave chase, but when I reached the top, the child was gone. The thing turned its head toward me, and the hunt began. I barely escaped into the back attic room and locked the door.",
		"Entry 15 — June 6, 2025 \n\nFive days. No food. I hear them all around — the sink gurgles, the greenhouse glass rattles, the attic floorboards groan. My name is Dr. Elias Rourke. I will not let them take me alive. The knife is ready."
	],
	"Jail Diary": [
		"Entry 1 — April 19, 2025 \n\nArrived at the Grisham estate as Eli requested. He claims to have captured an unknown organism from the plumbing. The man is meticulous, and the estate itself is… unsettling. Dust hangs in the air like it hasn’t been moved in years.",
		"Entry 2 — April 20, 2025 \n\nSaw the specimen in Cell 1. A pair of glowing eyes bathed in darkness staring as if it was expecting me. It seems to resist leaving water, yet can cling to stone without effort. When I leaned closer, it clicked at me — three sharp beats.",
		"Entry 3 — April 22, 2025 \n\nExplored the basement, most of it is damp stone and iron cages, but in the far corner there’s a wall unlike the rest — newer, reinforced. Eli avoided discussing it.",
		"Entry 4 — April 24, 2025 \n\nThere are strange noises here — gurgles in the walls, like something traveling inside the pipes. The family pretends not to notice.",
		"Entry 5 — April 28, 2025 \n\nAfter the loss of his wife, Eli hasn't left that attic. The boys and I have begun experimenting on Cell 1. In a fit of rage, it lashed out and bit me. It looks like it should be unbearable, but I feel so... alive.",
		"Entry 6 — April 30, 2025 \n\nTalked to Eli about the bite. He seemed so unphased by it though. How could he not care? I'm his best friend afterall. Doesn't matter, I don't need him. I don't need any of them.",
		"Entry 7 — May 4, 2025 \n\nI can hear them, whispering. Not my friends, no, I hear THEM. The things in the walls. They call out to me. They speak of the chosen. They speak of the vault. I stay up at night standing at the sinks talking to them. They're my friends now.",
		"Entry 8 — May 4, 2025 \n\nThe others treat me differently now. They grow quiet when I enter the room. \n	'Kell's been acting weird lately' \n	'He goes on and on about the sinks.' \nIt's not my fault they weren't chosen like I was.",
		"Entry 9 — May 5, 2025 \n\nEli locked me up. He said it was for some kind of 'observation.' I am not sick. I am not dangerous. I am simply the chosen one. They're just jealous that I can understand those creatures.",
		"Entry 10 — May 8, 2025 \n\nI dislike those newcomers. They look at me like an animal in a cage. They don't understand. ",
		"Entry 11 — May 9, 2025 \n\nEveryone gathers in that vault now. That thing Eli kept so secret. I can barely make out their voices. The creatures tell me what they say though.",
		"Entry 12 — May 10, 2025 \n\nFear. They fear me. Avoid me. \n	'Glowing eyes' \n	'The shadow' \n	I'm powerful. The bite is gone.",
		"\n\n\nI",
		"\n\n\nwas",
		"\n\n\nchosen.",
	],
	"Secret Book": [
		"Entry 1 — May 7, 2025 \n\nWe arrived at the estate today — four of us in total. Rourke claimed it was an emergency, yet he hasn’t shown himself. The others say he’s locked away in the attic, mourning his wife.",
		"Entry 2 — May 8, 2025 \n\nI once worked alongside Dr. Kell. Ambitious, yes, but always dismissed for his wild, unproven theories. Seeing him now in Cell 2 feels almost poetic. He always had the look of something caged — an animal pretending to be a man.",
		"Entry 3 — May 9, 2025 \n\nThat vault gives me the creeps. Some orange liquid flows throughout, pulsating as if alive. I asked about its source. No one gave a straight answer.",
		"Entry 4 — May 10, 2025 \n\nDr. Rourke finally emerged from the attic today, though I suspect it was only to check on Cell 2. Kell has been shouting for hours, claiming he is ‘the chosen.’ At night I hear him whispering — sometimes to Cell 1, sometimes to... something else.",
		"Entry 5 — May 12, 2025 \n\nWe carried more crates into the attic. No one will say what’s inside. There’s a tension in the air up there, a feeling like the room itself knows our intrusion. I can’t shake the suspicion that we’re not being told everything.",
		"Entry 6 — May 13, 2025 \n\nThe wailing from Cell 2 stopped suddenly — replaced by a single loud crash. When I arrived, Kell was gone. Heavy thumps echoed inside the walls, moving away. No one will tell me where he went... or if they even know.",
		"Entry 7 — May 16, 2025 \n\nI no longer go upstairs. The scratching is constant now, loud enough to make my ears ring. Earlier, a high-pitched screech tore through the hall, but I forced myself to ignore it. Some things are safer unheard.",
		"Entry 8 — May 18, 2025 \n\nI spent the day inside the vault. When I opened the door, a faint breeze brushed past me — carrying with it a sound like distant whispers. The chamber was empty, yet the walls seemed to hum. I’ve begun a quiet study of the orange liquid. I’ll keep my notes hidden.",
		"Entry 9 — May 20, 2025 \n\nAll remaining personnel have been confined to the basement. Rourke insists it’s for our safety, though I suspect he’s trying to keep us from something... or from leaving. I need to know what the liquid truly is.",
		"Entry 10 — May 21, 2025 \n\nI took a vial into Cell 1. The creature stared at it, unmoving. But the moment I stepped closer, it lunged. It sank its teeth into my leg, forcing me to drop the vial — the liquid splattering across the floor, some entering the wound.",
		"Entry 11 — May 22, 2025 \n\nI’ve set up my experiments in Cell 7. Few people come this far, so my work remains undisturbed. I stored several vials along the far wall, but when I turned back they were at my feet, as if drawn to me.",
		"Entry 12 — May 23, 2025 \n\nThe connection is undeniable. Since the bite, I can hear the creatures — not only as Kell did, but the liquid as well. It speaks without words, a deep longing to be released. This estate’s power source is no mere utility. It has purpose. And I intend to uncover it.",
		"Entry 13 — May 24, 2025 \n\nI followed its instructions. Gathered all the remaining scientists in the vault. When the creature emerged, it bit each of them. Soon, we will all share in this strength. We were chosen.",
	],
	"Wife's Journal": [
		"Entry 3 — March 22 2025 \n\nI found a locked door on the second floor I didn’t know existed. Elias brushed it off, said it was “storage.” It didn’t feel like storage.",
		"Entry 4 — March 26 2025 \n\nI heard tapping in the kitchen sink. I was sure of it. Eli swears it's just a contraction from the cold but I know what I heard. There's something living inside.",
		"Entry 5 — April 3 2025 \n\nI had trouble sleeping last night. The clicking was in the walls of the bedroom. Eli said he saw something moving. How I wish I were wrong.",
		"Entry 6 — April 10 2025 \n\nHe actually caught it. Eli captured that thing living in the drains and took it down to the basement. I'm just glad I can rest without hearing the noise. I thought it was talking to me.",
		"Entry 7 — April 15 2025 \n\nI try to keep going out to the garden. It's a nice escape from whatever is occurring in that house. I'm starting to have my doubts about coming here.",
		"Entry 8 — April 20 2025 \n\nEli's friends have arrived. They hang around in the basement all the time. I have no idea what goes on down there. I don't intend on finding out.",
		"Entry 9 — April 23 2025 \n\nI dream about the greenhouse now. In the dream, the plants lean toward me when I enter. When I wake, they’re still leaning."
	],
	"Floor Blueprints": [
		"■ ■ ■ ■ ■ ■ ■ ■ □ ■ \n■ ■ ■ ■ ■ ■ ■ ■ □ ■ \n■ ■ ■ ■ ■ ■ ■ ■ □ ■ \n■ ■ ■ ■ ■ ■ ■ ■ □ ■ \n■ ■ ■ ■ ■ ■ ■ ■ □ ■ \n■ ■ ■ ■ ■ ■ ■ ■ □ ■ \n■ ■ ■ ■ ■ ■ ■ ■ □ ■ \n■ ■ ■ ■ ■ □  □  □  □ ■ \n■ ■ ■ ■ ■ □ ■ ■ ■ ■ \n■ ■ ■ ■ ■ □ ■ ■ ■ ■ \n■ ■ ■ ■ ■ □ ■ ■ ■ ■ \n■ ■ ■ ■ ■ □ ■ ■ ■ ■ \n□  □  □  □  □  □ ■ ■ ■ ■ \n□ ■ ■ ■ ■ ■ ■ ■ ■ ■ \n□ ■ □  □  □  □  □  □  □ ■ \n□ ■ □ ■ ■ ■ ■ ■ □ ■ \n□ ■ □ ■ \n□ ■ □ ■ \n□  □  □ ■",
	],
	"Pipe Blueprints": [
		"in: (0,2) \nout: (3,6), (5,1), (7,4)",
	],
	"Full Power Blueprints": [
		"Power + (1,1), (1,6), (6,1), (7,1), (7,6) + all lit",
	],
	"Tutorial Book": [
		"This is how you use a desk to read longer items.",
		"Shorter items will be fully readable inside the inventory.",
		"Items can primarily be collected inside of the drawers you see on the left, but can also be inside other containers or in things that seem out of place.",
		"Be sure to right click on anything suspicious to ensure that it's not holding an item.",
		"Walking up to doors or stair cases can send the player to the next floor/room if all conditions are met.",
		"Some floors will have lockers to hide from the monsters. Walk up to them and right click to hide inside.",
		"When you're ready, proceed to the door and right click to return to the menu.",
	],
}

## Pause the game when the UI is open and update the page controls.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_page_controls()

## Populate the buttons based on the items in the player's inventory.
func populate_buttons():
	for child in button_container.get_children():
		child.queue_free()
	
	var inv_slots = player.get_inv()
	
	for item_name in inv_slots: 
		if is_readable(item_name):
			var btn = Button.new()
			btn.text = item_name
			btn.connect("pressed", func(): open_item(item_name))
			button_container.add_child(btn)

## Checks if the item is in the item_pages list.
func is_readable(item_id: String) -> bool:
	return item_id in item_pages

## Opens the item and displays the text on the first page.
func open_item(item_id: String):
	current_item_id = item_id
	current_page_index = 0
	show_current_page()
	update_page_controls()

## Show the current page that the player has turned to.
func show_current_page():
	if current_item_id != "" and current_item_id in item_pages:
		var pages = item_pages[current_item_id]
		if current_page_index >= 0 and current_page_index < pages.size():
			info_label.text = pages[current_page_index]
		else:
			info_label.text = "End"

## Update the page that the player has opened.
func update_page_controls():
	var has_item = current_item_id != "" and current_item_id in item_pages
	if has_item:
		var pages = item_pages[current_item_id]
		page_controls.get_node("PrevButton").disabled = current_page_index <= 0
		page_controls.get_node("NextButton").disabled = current_page_index >= pages.size() - 1
	else:
		page_controls.get_node("PrevButton").disabled = true
		page_controls.get_node("NextButton").disabled = true

## Button for opening the previous page.
func _on_PrevButton_pressed():
	if current_page_index > 0:
		current_page_index -= 1
		show_current_page()
		update_page_controls()

## Button for opening the next page.
func _on_NextButton_pressed():
	if current_page_index < item_pages[current_item_id].size() - 1:
		current_page_index += 1
		show_current_page()
		update_page_controls()

## Button for closing the UI.
func _on_CloseButton_pressed():
	get_tree().paused = false
	player.close_desk()
