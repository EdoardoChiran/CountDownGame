extends State

@export var waiting_state: State 

func enter_state() -> void:
	get_node("../../AnimationPlayer").play("PassBomb")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	switch_state.emit(waiting_state)
	get_tree().current_scene.players[get_tree().current_scene.current_holder].isPlayerHoldingBomb = false
	get_tree().current_scene.isAnimationFinished = true
