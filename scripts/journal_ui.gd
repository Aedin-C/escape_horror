extends Control

@onready var task_buttons_vbox = $PanelContainer/HBoxContainer/TaskButtons
@onready var task_description = $PanelContainer/HBoxContainer/TaskDisplay/TasksText

var is_open = false
var selected_task_id: String = ""

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	JournalManager.journal_updated.connect(_refresh_task_buttons)
	close()

func open():
	visible = true
	is_open = true
	get_tree().paused = true
	_refresh_task_buttons()

func close():
	visible = false
	is_open = false
	get_tree().paused = false
	
	selected_task_id = ""
	task_description.clear()

func _input(event):
	if event.is_action_pressed("j"):
		if is_open:
			close()
		else:
			open()

func _refresh_task_buttons():
	if not task_buttons_vbox:
		return
	
	for child in task_buttons_vbox.get_children():
		child.queue_free()

	for task_id in JournalManager.tasks:
		var t = JournalManager.tasks[task_id]
		var btn = Button.new()
		btn.text = task_id
		btn.name = task_id
		btn.pressed.connect(func(): _on_task_button_pressed(task_id))
		task_buttons_vbox.add_child(btn)

	# If nothing selected, clear display
	if selected_task_id == "":
		task_description.clear()

func _on_task_button_pressed(task_id: String):
	selected_task_id = task_id
	var t = JournalManager.tasks[task_id]
	task_description.clear()
	task_description.append_text(t["description"])
