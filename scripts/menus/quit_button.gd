extends Button

enum QuitProcedure { MAIN_MENU, GAME }

@export var quit_procedure: QuitProcedure = QuitProcedure.GAME

func _on_button_up() -> void:
	match quit_procedure:
		QuitProcedure.MAIN_MENU:
			quit_to_main_menu()
		QuitProcedure.GAME:
			quit_entire_game()
		_:
			push_error("An invalid QuitProcedure was attempted with the quit button")

func quit_to_main_menu() -> void:
	var MAIN_MENU := load("res://scenes/menus/main_menu.tscn")
	
	if MAIN_MENU != null:
		unpause_game()
		get_tree().change_scene_to_packed(MAIN_MENU)
	else:
		push_error("No main menu scene has been loaded for the quit button")
	

func quit_entire_game() -> void:
	var current_scene_tree := get_tree()
	current_scene_tree.root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	
	current_scene_tree.quit()


func unpause_game() -> void:
	get_tree().paused = false
