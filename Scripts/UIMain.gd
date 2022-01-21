extends CanvasLayer
onready var LevelButton = preload("res://Assets/LevelButton.tscn")
func LevelComplete():
	$UIMain/VictoryMain.visible = true
	$UIMain/Buttons.visible = false
	$UIMain/VictoryMain/AnimationPlayer.play("Appear")

func stopAnim():
	$UIMain/VictoryMain.rect_size = Vector2(0, 100)
	$UIMain/VictoryMain/AnimationPlayer.stop()
	$UIMain/Buttons.visible = true
	$UIMain/VictoryMain.visible = false

func startLevelUI():
	$UIMain/Buttons.visible = true
	
func levelSelected(level):
	LevelHandler.loadLevel(level)
	$LevelSelect.visible = false

func showLevels():
	$LevelSelect.visible = true
	$UIMain/Buttons.visible = false

func createLevels(levels : PoolStringArray):
	$UIMain/Buttons.visible = false
	for level in levels:
		var button = LevelButton.instance()
		var text:String = level.replace("Level", "")
		button.get_node("LevelName").text = text
		button.connect("pressed", self, "levelSelected", [text])
		$LevelSelect/Scroll/Margin/GridContainer.add_child(button)
	$LevelSelect.visible = true

func _ready():
	$UIMain/Buttons/Restart.connect("pressed", LevelHandler, "restart")
	$UIMain/Buttons/Menu.connect("pressed", LevelHandler, "clearLevel")
	$UIMain/Buttons/Menu.connect("pressed", self, "showLevels")
