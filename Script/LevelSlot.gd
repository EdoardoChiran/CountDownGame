extends Node

@onready var LevelLabel: Label = $LevelSelector/LevelLabel
@onready var LevelButton: Button = $LevelSelector

var levelName: String

func _ready() -> void:
	display_text(get_level_name())
	levelName = get_level_name()

func display_text(message: String) -> void:
	LevelLabel.text = message

func _on_level_selector_pressed() -> void:
	level_selection()
	get_tree().change_scene_to_file("res://Scene/Level.tscn")

func get_level_name() -> String:
	return get_tree().current_scene.level.levelList[get_tree().current_scene.levelCounter].levelName 

func level_selection() -> void:
	Progression.chosenLevel = get_level_number(levelName)
	Progression.isLevelRunning[Progression.chosenLevel] = true

func get_level_number(_name: String) -> int:
	for i in get_tree().current_scene.level.levelList.size():
		if _name == "Level " + str(i):
			return i
	return 0
