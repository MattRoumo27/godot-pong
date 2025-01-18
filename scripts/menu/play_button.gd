extends Button

@export var game_scene: PackedScene

func _on_button_up() -> void:
	switch_to_the_game_scene()
	
func switch_to_the_game_scene() -> void:
	var current_scene_tree := get_tree()
	current_scene_tree.change_scene_to_packed(game_scene)
