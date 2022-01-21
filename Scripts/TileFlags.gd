extends Node

var Directions:Dictionary = {
	'0': Vector2(0, -1),
	'16': Vector2(-1, 0),
	'10': Vector2(0, 1),
	'22': Vector2(1, 0),
}
var Slope:Dictionary = {
	'0': Vector2(-1, 0),
	'10': Vector2(1, 0),
	'16': Vector2(0, 1),
	'22': Vector2(0, -1),
}
var Tiles:Dictionary = {
	'0': 'Regular',
	'1': 'Conveyor',
	'2': 'Goal',
	'3': 'Slope',
}
