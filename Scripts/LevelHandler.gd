extends Node

var currentLevel = 1

func retrieveLevels() -> PoolStringArray:
	var files = []
	var dir = Directory.new()
	dir.open("res://Levels")
	dir.list_dir_begin()
	
	while true:
		var file:String = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file != "MainMenu.tscn" and file != "UIMain.tscn":
			files.append(file.get_basename())

	return files

func loadLevel(level:String):
	
	# load the level
	if int(level):
		currentLevel = int(level)
	print("Loading level")
	clearLevel()
	var newLevel:PackedScene = load("res://Levels/Level" + level + ".tscn")
	if is_instance_valid(newLevel):
		var scene = newLevel.instance()
		get_tree().root.call_deferred("add_child", scene)
		scene.name = "Level"
		print("Loaded " + level)
		UiMain.startLevelUI()
	else:
		UiMain.showLevels()

func clearLevel():
	var levelM = get_node_or_null("../Level")
	if levelM:
		levelM.name = "clearing"
		levelM.queue_free()

func LevelComplete():
	currentLevel += 1
	yield(get_tree().create_timer(2.0), "timeout")
	UiMain.stopAnim()
	loadLevel(str(currentLevel))

func restart():
	print("Attempting a restart")
	loadLevel(str(currentLevel))
	
func _ready():
	var files = retrieveLevels()
	UiMain.createLevels(files)
