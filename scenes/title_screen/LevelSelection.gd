extends CenterContainer


var current_index = 1 setget _set_current_index
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
	var index = 0
	var custom_levels = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
	custom_levels.index = index
	custom_levels.level_data = {"name": "Level editor"}
	custom_levels.connect("selected", self, "_on_LevelSelectionItem_selected", [0])
	$Center.add_child(custom_levels)
	index += 1
	
	var progress = load_progress()
	
	# load level dir into list
	var level_list = Array()
	var dir := Directory.new()
	var level_dir = "res://scenes/levels/"
	dir.open(level_dir)
	dir.list_dir_begin(true)
	var next: String =  dir.get_next()
	while next != "":
		if next.get_extension() == "json":
			level_list.append(next)
		next = dir.get_next()
	
	dir.list_dir_end()
	
	level_list.sort()
	
	for lvl in level_list:
		var level_selection = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
		level_selection.index = index
		var file = File.new()
		file.open(level_dir + lvl, File.READ)
		var level_data = parse_json(file.get_as_text())
		file.close()

		var level_name = level_data["level_name"] if level_data.has("level_name") else lvl .get_basename()

		# get number of stars
		var stars_max = 0	
		if level_data.has("stars"):
			stars_max = len(level_data["stars"])

		var stars = 0
		var state = level_selection.LevelState.UNLOCKED if index == 1 else level_selection.LevelState.LOCKED
		var level_progress = Dictionary()
		# try to get progress of level
		if progress.has(str(index)):
			level_progress = progress[str(index)]
			if level_progress.has("state"):
				state = level_progress["state"]
			if level_progress.has("stars_collected"):
				stars = level_progress["stars_collected"]

		var level_selection_data = {
			"index": index,
			"name": level_name,
			"state": state,
			"stars": stars,
			"stars_max": stars_max,
			"level_path": dir.get_current_dir() + "/" + lvl,
			"next_levels": level_list.slice(index, len(level_list))
		}
		level_selection.level_data = level_selection_data
		level_selection.connect("selected", self, "_on_LevelSelectionItem_selected", [index])
		$Center.add_child(level_selection)
		
		index += 1
	



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
		SceneLoader.goto_scene("res://scenes/Game.tscn", {
			"level_num": current_index,
			"level_path": level.level_data["level_path"],
			"next_levels": level.level_data["next_levels"]
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
