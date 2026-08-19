extends State

@export var pass_state: State

func update(_delta: float) -> void:
	if Input.is_action_just_pressed("PassTurn") and get_node("../..").playerNumber == get_tree().current_scene.current_holder:
		if get_tree().current_scene.bomb.tickingTurns > 0:
			switch_state.emit(pass_state)
