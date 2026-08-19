extends Node

#Errori
#1: Il software non aspetta il timer, quindi process deve andarsene a fanculo, mettendo il passaggio a chiamata di input.

#Please Take The Bomb! Gioco puzzle, contro varie IA che ti andranno contro per far esplodere la bomba nelle tue mani.
#Regola numero 1: Si e' costretti a passare la bomba ogni turno, fino all'esplosione.
#Regola numero 2: La bomba puo' essere lanciata al nemico piu' avanti, una volta per livello

const PLAYERS_SPAWN_SCENE: PackedScene = preload("res://Scene/LevelSpawnLocations.tscn")
const ANIMATION_TIME: float = 0.75
var bomb: Bomb
var players: Array[Players] = []

@export var level: LevelList
@export var abilities: Array[Ability] = []

@onready var MessageLabel: Label = $MessageLabel
@onready var BombTicksLabel: Label = $BombTicksLabel
@onready var AbilityGrid: GridContainer = $AbilityContainer
@onready var label = $Label

var current_holder: int = 0
var level_counter: int = 0
var current_level_bomb_ticks: int 

var isGameRunningChecked: bool = false
var isAnimationFinished: bool = true

var totalPlayers: int 

var playerScene: Node2D

var abilityReady: String

#setup and input reading
func _ready() -> void:
	level_counter = Progression.chosenLevel
	print(current_holder)
	if not isGameRunningChecked:
		which_level_is_running_check()
		isGameRunningChecked = true
	
	level_initialiser()

func _process(_delta: float) -> void:
	label.text = str(current_holder)

func _input(event) -> void:
	if event.is_action_pressed("PassTurn"):
		pass_function()
	if event.is_action_pressed("NextLevel"):
		level_reset_function()

func pass_function() -> void:
	if not bomb.isBombExploded:
		bomb_pass()
	 
	else:
		display_text("")

func level_reset_function() -> void:
	if players[current_holder].isPlayerHoldingBomb == true and bomb.isBombExploded == true:
		if players[current_holder].isPlayerBot == true:
			advance_level()
		elif players[current_holder].isPlayerBot == false:
			reset()
			bomb.tickingTurns = current_level_bomb_ticks

#Game Logic functions
func is_bomb_exploding() -> void:
	if bomb.tickingTurns == 0:
		bomb.isBombExploded = true

func bomb_pass() -> void:
	if isAnimationFinished and not bomb.isBombExploded and Input.is_action_just_pressed("PassTurn"):
		check_bomb_holder()
		bomb.tickingTurns = max(0, bomb.tickingTurns - 1)
	refresh_ticks_display()
	is_bomb_exploding()

func check_bomb_holder() -> void:
	if not players[current_holder].isPlayerBot:
		isAnimationFinished = false
		ability_activation()
		pass_moving_index()
		abilityReady = ""
	elif players[current_holder].isPlayerBot:
		isAnimationFinished = false
		pass_moving_index()

func pass_moving_index() -> void:
	await get_tree().create_timer(0.1).timeout
	if bomb.hasBombRotationBeenReversed == false:
		positive_pass_moving_index()
	else:
		negative_pass_moving_index()

func positive_pass_moving_index() -> void:
	if current_holder >= totalPlayers - 1:
		current_holder = 0
		display_text("You own the bomb")
	else:
		current_holder += 1
		check_player_passives()
		display_text("Player " + str(current_holder) + " owns the bomb")
	players[current_holder].isPlayerHoldingBomb = true

func negative_pass_moving_index() -> void:
	if current_holder == 0:
		current_holder = totalPlayers - 1
		display_text("Player " + str(current_holder) + " owns the bomb")
	else:
		current_holder -= 1
		check_player_passives()
		display_text("You own the bomb")
	players[current_holder].isPlayerHoldingBomb = true

func check_player_passives() -> void:
	if players[current_holder].isPlayerExcited:
		bomb.tickingTurns = max(0, bomb.tickingTurns - 1)

#UI functions
func display_text(message) -> void:
	if bomb.tickingTurns > 0:
		if abilityReady != "":
			MessageLabel.text = abilityReady + " ability used! " + message
		else:
			MessageLabel.text = message
	else:
		if current_holder == 0:
			MessageLabel.text = "You lost"
		else:
			MessageLabel.text = "You win! Bomb exploded on player " + str(current_holder)

func refresh_ticks_display() -> void:
	BombTicksLabel.text = str(bomb.tickingTurns)

func _on_back_to_menu_pressed() -> void:
	Progression.isLevelRunning[level_counter] = false
	get_tree().change_scene_to_file("res://Scene/Menu.tscn")

#Loading Entities Functions
func load_bomb() -> void:
	bomb = level.levelList[level_counter].bombType
	current_level_bomb_ticks = bomb.tickingTurns
	refresh_ticks_display()

func load_players() -> void:
	display_text("You own the bomb")
	for i in level.levelList[level_counter].playerList.size():
		players.append(level.levelList[level_counter].playerList[i])
	players[current_holder].isPlayerHoldingBomb = true

func load_all_entities() -> void:
	if Progression.isLevelRunning[level_counter]:
		load_bomb()
		load_players()
	else:
		return

func level_initialiser() -> void:
	totalPlayers = level.levelList[level_counter].playerList.size()
	if not level.levelList[level_counter].hasLevelBeenInitialised:
		level.levelList[level_counter].hasLevelBeenInitialised = true
		load_all_entities()
		add_child(PLAYERS_SPAWN_SCENE.instantiate())

#On ending level functions
func reset() -> void:
	players.clear()
	bomb_reset()
	current_holder = 0
	on_level_start_check(true)
	level_initialiser()
	players[current_holder].isPlayerHoldingBomb = true
	display_text("You own the bomb")

func bomb_reset() -> void:
	bomb.isBombExploded = false
	bomb.tickingTurns = current_level_bomb_ticks 

func advance_level() -> void:
	level.levelList[level_counter].isLevelCompleted = true
	remove_child($LevelSpawnLocations)
	if level_counter == level.levelList.size() - 1:
		get_tree().change_scene_to_file("res://Scene/Menu.tscn")
		return
	
	on_level_start_check(false)
	level_counter += 1
	Progression.isLevelUnlocked[level_counter] = true
	reset()
	current_level_bomb_ticks = bomb.tickingTurns

func on_level_start_check(check: bool) -> void:
	level.levelList[level_counter].hasLevelBeenInitialised = not check #Da riguardare perche' cambia lo stato del livello appena completato da inizializzato. C'e' da capire se questo blocca la scelta del livello.
	Progression.isLevelRunning[level_counter] = check

#Debug Functions
func which_level_is_running_check() -> void:
	for i in level.levelList.size():
		if not Progression.isLevelRunning[i]:
			return
		else:
			Progression.isLevelRunning[level_counter] = true
			level_counter = i

func catch_out_of_bound_level() -> void:
	if level_counter == level.levelList.size() - 1:
		get_tree().change_scene_to_file("res://Scene/Menu.tscn")

#Abilities functions -> on a press of a button, you prepare the ability for the next action
func ability_activation() -> void:
	for i in abilities.size():
		if abilityReady == abilities[i].abilityName:
			ability(abilityReady)

func ability(abilityName: String) -> void:
	match abilityName:
		"Bomb Skip Player":
			ability_bomb_skip_player()
		"Reversed Passing Order":
			ability_reverse_passing_order()

func _on_grid_container_bomb_skip_held() -> void:
	if abilityReady != "Bomb Skip Player":
		abilityReady = "Bomb Skip Player"
	elif abilityReady == "Bomb Skip Player":
		abilityReady = ""

func ability_bomb_skip_player() -> void:
	bomb.hasBombBeenLaunched = true
	current_holder += 1

func _on_grid_container_bomb_reverse_order() -> void:
	if abilityReady != "Reversed Passing Order":
		abilityReady = "Reversed Passing Order"
	elif abilityReady == "Reversed Passing Order":
		abilityReady = ""

func ability_reverse_passing_order() -> void:
	bomb.hasBombRotationBeenReversed = not bomb.hasBombRotationBeenReversed
