extends CenterContainer


var current_index = 0 setget _set_current_index


# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	var custom_levels = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
	custom_levels.index = index
	custom_levels.level_data = {"name": "Level editor"}
	custom_levels.connect("selected", self, "_on_LevelSelectionItem_selected", [0])
	$Center.add_child(custom_levels)
	index += 1
	
	
	var dir := Directory.new()
	dir.open("res://scenes/levels")
	
	dir.list_dir_begin(true)
	var next: String =  dir.get_next()
	while next != "":
		if next.get_extension() == "json":
			var level = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
			level.index = index
			
			var level_data = {
				"index": index,
				"name": next.get_basename(),
				"state": level.LevelState.UNLOCKED,
				#"stars": randi() % 9,
				#"stars_max": 8,
				"level_path": dir.get_current_dir() + "/" + next
			}
			level.level_data = level_data
			level.connect("selected", self, "_on_LevelSelectionItem_selected", [index])
			$Center.add_child(level)
			
			index += 1
		
		next = dir.get_next()
	
	dir.list_dir_end()
	
	"""
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
	"""


func _input(event):
	if Input.is_action_just_pressed("level_selection_right") and current_index < $Center.get_child_count() - 1:
		self.current_index += 1
	
	if Input.is_action_just_pressed("level_selection_left") and current_index > 0:
		self.current_index -= 1
	
	if Input.is_action_just_pressed("ui_accept"):
		open_selected_level()


func open_selected_level():
	if current_index == 0:
		SceneLoader.goto_scene("res://scenes/level_editor/CustomLevelsManager.tscn")
	else:
		var level = $Center.get_child(current_index)
		print(level.level_data["level_path"])
		SceneLoader.goto_scene("res://scenes/Game.tscn", {
			"level_path": level.level_data["level_path"]
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
