extends ColorRect

@onready var AbilityLabel: Label = $AbilityLabel
@onready var AbilityStatus: ColorRect = $"."

var abilityName: String

func _ready() -> void:
	abilityName = get_parent().abilityName
	AbilityLabel.text = get_parent().abilityName

func _process(_delta: float) -> void:
	if get_tree().current_scene.abilityReady == abilityName:
		AbilityStatus.color = "3fff00"
		AbilityLabel.modulate = "black"
	else:
		AbilityStatus.color = "a20000"
		AbilityLabel.modulate = "white"
