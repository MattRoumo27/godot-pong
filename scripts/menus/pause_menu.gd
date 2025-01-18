extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause_state()

func _on_resume_button_button_up() -> void:
	toggle_pause_state()

func toggle_pause_state() -> void:
	var current_scene_tree := get_tree()
	current_scene_tree.paused = !current_scene_tree.paused
	
	toggle_pause_menu_visibility()

func toggle_pause_menu_visibility() -> void:
	if is_visible_in_tree():
		hide()
	else:
		show()
