extends Node

const PLAYER_MODEL_PATH: PackedScene = preload("uid://bqwf7m3jnp0js")
@onready var spawningPath: Line2D = $Line2D

@export var lenght: int = 500

var player: Array[Node2D]
var baseAngle: int = 180
var position: Vector2i = Vector2i(0, 0)
var playerNumber: int = 0

func _ready() -> void:
	spawningPath.clear_points()
	position = Vector2i(0, 0)
	var vertexNumber: int = get_tree().current_scene.players.size()
	var sumOfAngles = 180 * max(1 , vertexNumber - 2)
	var angle = sumOfAngles / (vertexNumber * max(1 , vertexNumber - 2))
	var currentAngle = angle
	lenght = lenght / max(2, vertexNumber/sqrt(vertexNumber))
	for i in vertexNumber: 
		playerNumber = i
		player_spawn(i, currentAngle, angle)
		spawningPath.add_point(position, i)
		@warning_ignore("narrowing_conversion")
		position = Vector2i(x_calculation(currentAngle), y_calculation(currentAngle))
		currentAngle = currentAngle + angle * 2

func x_calculation(angle: int) -> float:
	return position.x + lenght*cos(deg_to_rad(angle))

func y_calculation(angle: int) -> float:
	return position.y + (-lenght*sin(deg_to_rad(angle)))

func player_spawn(i: int, currentAngle: int, angle: int) -> void:
	player.append(PLAYER_MODEL_PATH.instantiate())
	player[i].position = position
	if i == 0:
		player[i].rotation = -deg_to_rad(currentAngle - angle)
	else:
		player[i].rotation = -deg_to_rad(currentAngle - angle)
	add_child(player[i])
