extends Node2D

@onready var nameLabel: Label = $NameLabel
var playerNumber: int

func _ready() -> void:
	playerNumber = get_parent().playerNumber
	nameLabel.text = get_tree().current_scene.players[playerNumber].playerName
	nameLabel.rotation = deg_to_rad((180 * max(1, get_tree().current_scene.players.size() - 2)) * playerNumber)
