class_name Levels
extends Resource

@export var playerList: Array[Players] = []
@export var bombType: Bomb

@export var levelName: String
@export var levelNumber: int 

@export var hasLevelBeenInitialised: bool = false

var isLevelCompleted: bool = false
var isLevelUnlocked: bool = true
var isLevelVisible: bool = false
