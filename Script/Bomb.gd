class_name Bomb
extends Resource


@export var tickingTurns: int = 3

@export var canBombBeLaunched: bool = false
@export var canBombBeReversed: bool = false

var isBombExploded: bool = false

var hasBombBeenLaunched: bool = false
var hasBombRotationBeenReversed: bool = false
