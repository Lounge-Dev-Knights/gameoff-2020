extends CenterContainer


var current_index = 0 setget _set_current_index
var progress_path = "user://progress.json"


	

func load_progress():
	var file = File.new()
	file.open(progress_path, File.READ)
	var progress = parse_json(file.get_as_text())
	file.close()

	if progress == null:
		return Dictionary()
	return progress
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var custom_levels = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
	custom_levels.index = 0
	custom_levels.level_data = {"name": "Level editor"}
	custom_levels.connect("selected", self, "_on_LevelSelectionItem_selected", [0])
	$Center.add_child(custom_levels)
	
	var progress = load_progress()
	
	for i in range(1, 9):
		var level_select = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
		
		# abort if level doesn't exist
		var level_path = "res://scenes/levels/level" + str(i) + ".json"
		var file = File.new()
		if not file.file_exists(level_path):
			break

		
		file.open(level_path, File.READ)
		var level_data = parse_json(file.get_as_text())
		file.close()
		
		
		var level_name = level_data["level_name"] if level_data.has("level_name") else "Level %d" % (i)
		
		# get number of stars
		var stars_max = 0	
		if level_data.has("stars"):
			stars_max = len(level_data["stars"])
		
		var stars = 0
		var state = level_select.LevelState.UNLOCKED if i == 1 else level_select.LevelState.LOCKED
		var level_progress = Dictionary()
		# try to get progress of level
		if progress.has(str(i)):
			level_progress = progress[str(i)]
			if level_progress.has("state"):
				print("state ", level_progress["state"])
				state = level_progress["state"]
			if level_progress.has("stars_collected"):
				stars = level_progress["stars_collected"]


		level_select.index = i
		var level_select_data = {
			"name": level_name,
			"state": state,
			"stars": stars,
			"stars_max": stars_max
		}
		level_select.level_data = level_select_data
		level_select.connect("selected", self, "_on_LevelSelectionItem_selected", [i])
		$Center.add_child(level_select)
	
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
			"level_path": "res://scenes/levels/level" + str(current_index) + ".json",
			"level_num": current_index
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
