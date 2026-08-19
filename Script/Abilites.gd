extends GridContainer

const ABILITY_SLOT: PackedScene = preload("uid://bmbpev0cvpdu6")

signal bombSkipHeld()
signal bombReverseOrder()

var bomb: Bomb

var abilityName: String

func _ready() -> void:
	fill_ability_grid()

func _process(_delta: float) -> void:
	bomb = get_tree().current_scene.bomb
	abilities_group()

func fill_ability_grid() -> void:
	var abilitySlotTemp: Array[Node] = []
	for i in get_tree().current_scene.abilities.size():
		abilitySlotTemp.append(ABILITY_SLOT.instantiate()) 
		abilityName = get_level_name(i)
		add_child(abilitySlotTemp[i])

func get_level_name(i: int) -> String:
	return get_tree().current_scene.abilities[i].abilityName

#Abilities signals sender functions
func abilities_group() -> void:
	bomb_skip_player()
	bomb_reverse_pass_order()

func bomb_skip_player() -> void:
	if Input.is_action_just_pressed("SkipPlayer") and bomb.hasBombBeenLaunched == false and bomb.canBombBeLaunched == true:
		emit_signal("bombSkipHeld")

func bomb_reverse_pass_order() -> void:
	if Input.is_action_just_pressed("ReverseOrder") and bomb.hasBombRotationBeenReversed == false and bomb.canBombBeReversed == true:
		emit_signal("bombReverseOrder")
