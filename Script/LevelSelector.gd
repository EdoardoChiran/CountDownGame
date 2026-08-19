extends Control

const LEVEL_SLOT: PackedScene = preload("res://Scene/levelSlot.tscn")

@export var level: LevelList

@onready var levelContainer: GridContainer = $GridContainer

var levelCounter: int = 0

func _ready() -> void:
	levelCounter = 0
	fill_level_grid()

func fill_level_grid() -> void:
	var levelSlotTemp: Array[Node] = []
	for i in level.levelList.size():
		levelCounter = i
		levelSlotTemp.append(LEVEL_SLOT.instantiate()) 
		levelContainer.add_child(levelSlotTemp[i])
		check_level_unlock(levelSlotTemp, i)

func game_first_launch_fix(i: int) -> void:
	Progression.isLevelRunning.append(false)
	if i == 0:
		Progression.isLevelUnlocked.append(true)
	elif i > 0 and i < level.levelList.size() - 1:
		Progression.isLevelUnlocked.append(false)
	elif i >= level.levelList.size() - 1:
		Progression.isLevelUnlocked.append(false)
		Progression.isGameFirstLaunch = false

func check_level_unlock(levelSlotTemp: Array[Node], i: int) -> void:
	if Progression.isGameFirstLaunch:
		game_first_launch_fix(i)
		if i == 0:
			levelSlotTemp[i].visible = not level.levelList[i].isLevelVisible
		else:
			levelSlotTemp[i].visible = level.levelList[i].isLevelVisible
		return
	elif not Progression.isGameFirstLaunch:
		if Progression.isLevelUnlocked[i] == false and i != 0: #exception for first level
			levelSlotTemp[i].visible = Progression.isLevelUnlocked[i]
