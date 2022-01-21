extends KinematicBody

var CurrentPosition:Vector3 = Vector3(-1, 0, 0)
var Moving:Vector2 = Vector2(0, 0)
var canMove:bool = true
onready var Grid:GridMap = get_node("../Tiles")
	
func tileHasCollision(pos):
	var index:int = Grid.get_cell_item(pos.x, pos.y, pos.z)
	print(index, pos)
	if index == -1:
		return false
	if TileFlags.Tiles[str(index)] == 'Slope':
		var dir = Grid.get_cell_item_orientation(pos.x, pos.y, pos.z)
		print(dir)
		if Moving == TileFlags.Slope[str(dir)]:
			CurrentPosition += Vector3(Moving.x, 1, Moving.y)
	return true

func checkTile(pos):
	var index:int = Grid.get_cell_item(pos.x, pos.y, pos.z)
	if index == -1:
		var newPos = Vector3(CurrentPosition.x, CurrentPosition.y - 1, CurrentPosition.z)
		$Tween.interpolate_property(self, "translation", self.translation, newPos * Vector3(2, 2, 2) + Vector3(1, 1, 1), 0.1)
		$Tween.start()
		yield($Tween, "tween_completed")
		CurrentPosition = newPos
		print(CurrentPosition)
		if CurrentPosition.y > -6:
			checkTile(CurrentPosition - Vector3(0, 1, 0))
		else:
			CurrentPosition = Vector3(0, 0, 0)
			LevelHandler.restart()
		return
	if TileFlags.Tiles[str(index)] == 'Conveyor':
		var dir = Grid.get_cell_item_orientation(pos.x, pos.y, pos.z)
		if TileFlags.Directions.has(str(dir)):
			var actualDir = TileFlags.Directions[str(dir)]
			var newPos = Vector3(CurrentPosition.x + actualDir.x, CurrentPosition.y, CurrentPosition.z + actualDir.y)
			if not tileHasCollision(newPos):
				$Tween.interpolate_property(self, "translation", self.translation, newPos * Vector3(2, 2, 2) + Vector3(1, 1, 1), 0.13)
				$Tween.start()
				yield($Tween, "tween_completed")
				CurrentPosition = newPos
				checkTile(CurrentPosition - Vector3(0, 1, 0))
			else:
				canMove = true
	elif TileFlags.Tiles[str(index)] == 'Regular':
		canMove = true
	elif TileFlags.Tiles[str(index)] == 'Goal':
		UiMain.LevelComplete()
		LevelHandler.LevelComplete()
		pass

func _process(delta):
	if Input.is_action_just_released('move_forwards') and Moving == Vector2(0, -1):
		Moving = Vector2(0, 0)
		
	if Input.is_action_just_released('move_down') and Moving == Vector2(0, 1):
		Moving = Vector2(0, 0)
		
	if Input.is_action_just_released('move_left') and Moving == Vector2(-1, 0):
		Moving = Vector2(0, 0)
		
	if Input.is_action_just_released('move_right') and Moving == Vector2(1, 0):
		Moving = Vector2(0, 0)
		
	if canMove and Moving != Vector2(0, 0):
		canMove = false
		var newPos = Vector3(CurrentPosition.x + Moving.x, CurrentPosition.y, CurrentPosition.z + Moving.y)
		if not tileHasCollision(newPos):
			$Tween.interpolate_property(self, "translation", self.translation, newPos * Vector3(2, 2, 2) + Vector3(1, 1, 1), 0.175)
			$Tween.start()
			yield($Tween, "tween_completed")
			CurrentPosition = newPos
			checkTile(CurrentPosition - Vector3(0, 1, 0))
		else:
			canMove = true

func _unhandled_key_input(event:InputEventKey):
	if Input.is_action_pressed('move_forwards'):
		Moving = Vector2(0, -1)
		
	if Input.is_action_pressed('move_down'):
		Moving = Vector2(0, 1)

	if Input.is_action_pressed('move_right'):
		Moving = Vector2(1, 0)
		
	if Input.is_action_pressed('move_left'):
		Moving = Vector2(-1, 0)
