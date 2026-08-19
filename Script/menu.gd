extends Control

func _on_level_selector_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/LevelSelector.tscn")
