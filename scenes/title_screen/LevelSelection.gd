extends CenterContainer


var current_index = 0 setget _set_current_index


# Called when the node enters the scene tree for the first time.
func _ready():
	var custom_levels = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
	custom_levels.index = 0
	custom_levels.level_data = {"name": "Level editor"}
	custom_levels.connect("selected", self, "_on_LevelSelectionItem_selected", [0])
	$Center.add_child(custom_levels)
	
	for i in range(1, 3):
		var level = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
		level.index = i
		var level_data = {
			"name": "Level %d" % (i),
			"state": level.LevelState.COMPLETED,
			"stars": randi() % 9,
			"stars_max": 8
		}
		level.level_data = level_data
		level.connect("selected", self, "_on_LevelSelectionItem_selected", [i])
		$Center.add_child(level)
	
	for i in range(3, 4):
		var level = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
		level.index = i
		var level_data = {
			"name": "Level %d" % (i),
			"state": level.LevelState.UNLOCKED,
			"stars": 0,
			"stars_max": 8
		}
		level.level_data = level_data
		level.connect("selected", self, "_on_LevelSelectionItem_selected", [i])
		$Center.add_child(level)
	
	for i in range(4, 7):
		var level = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
		level.index = i
		var level_data = {
			"name": "Level %d" % (i),
			"state": level.LevelState.LOCKED
		}
		level.level_data = level_data
		level.connect("selected", self, "_on_LevelSelectionItem_selected", [i])
		$Center.add_child(level)
	
	self.current_index = 1


func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_right") and current_index < $Center.get_child_count() - 1:
		self.current_index += 1
	
	if Input.is_action_just_pressed("ui_left") and current_index > 0:
		self.current_index -= 1
	
	if Input.is_action_just_pressed("ui_accept"):
		open_selected_level()


func open_selected_level():
	if current_index == 0:
		SceneLoader.goto_scene("res://scenes/level_editor/CustomLevelsManager.tscn")
	else:
		SceneLoader.goto_scene("res://scenes/Game.tscn", {
			"level_path": "res://scenes/levels/test_level.json"
		})


func _on_LevelSelectionItem_selected(index):
	if index == current_index:
		open_selected_level()
	else:
		self.current_index = index


func _set_current_index(new_index: int):
	current_index = new_index
	get_tree().call_group("levels", "_set_current_index", current_index)
	SoundEngine.play_sound("MoonThrowing")
