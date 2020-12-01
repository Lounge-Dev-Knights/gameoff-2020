extends CenterContainer

const DEFAULT_LEVEL_LIST = [
	"res://scenes/levels/Tutorial I.json",
	"res://scenes/levels/Tutorial II.json",
	"res://scenes/levels/Tutorial III.json",
	"res://scenes/levels/Reticulum.json",
	"res://scenes/levels/Aquila.json",
	"res://scenes/levels/Horologium.json",
	"res://scenes/levels/Pisces.json",
	"res://scenes/levels/Pavo.json",
	"res://scenes/levels/Tutorial_Waypoint.json",
	"res://scenes/levels/Lacerta.json",
	"res://scenes/levels/Auriga.json",
	"res://scenes/levels/Taurus.json",
	"res://scenes/levels/Scorpius.json",
	"res://scenes/levels/Triangulum.json",
	"res://scenes/levels/Sagittarius.json",
	"res://scenes/levels/Draco.json",
	"res://scenes/levels/Lyra.json",
	"res://scenes/levels/Hydra.json",
	"res://scenes/levels/Cassiopeia.json",
	"res://scenes/levels/Ursa Major.json",
	"res://scenes/levels/Orion.json",
	"res://scenes/levels/Fornax.json",
	"res://scenes/levels/Sagitta.json",
	"res://scenes/levels/Phoenix.json",
]


var current_index = 1 setget _set_current_index
var progress_path = "user://progress.json"
var level_selection

var god = 'Fortuna'

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
	var level_number = 1
	
	var custom_levels = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
	custom_levels.index = index
	custom_levels.level_data = {"name": "Level editor"}
	custom_levels.connect("selected", self, "_on_LevelSelectionItem_selected", [0])
	$Center.add_child(custom_levels)
	index += 1
	
	var progress = load_progress()
	
	# load level dir into list
	#	var level_list = Array()
	#	var dir := Directory.new()
	#	var level_dir = "res://scenes/levels/"
	#	dir.open(level_dir)
	#	dir.list_dir_begin(true)
	#	var next: String =  dir.get_next()
	#	while next != "":
	#		if next.get_extension() == "json":
	#			level_list.append(level_dir + next)
	#		next = dir.get_next()
	#
	#	dir.list_dir_end()
	#
	#	level_list.sort()
	var level_list = DEFAULT_LEVEL_LIST
	
	for lvl in level_list:
		level_selection = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
		level_selection.index = index
		
		var file = File.new()
		file.open(lvl, File.READ)
		var level_data = parse_json(file.get_as_text())
		file.close()

		var level_name = level_data["level_name"] if level_data.has("level_name") else lvl.split('/')[-1].split(".json")[0]
		
		if level_name != "Level Editor" and !level_name.begins_with("Tutorial"):
			level_name = "%s %s" % [integerToRoman(level_number), level_name]
			level_number += 1
		
		# get number of stars
		var stars_max = 0	
		if level_data.has("stars"):
			stars_max = len(level_data["stars"])

		var stars = Array()
		var state = level_selection.LevelState.UNLOCKED if index == 1 else level_selection.LevelState.LOCKED
		var level_progress = Dictionary()
		# try to get progress of level
		if progress.has(lvl):
			level_progress = progress[lvl]
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
			"level_path": lvl,
			"next_levels": level_list.slice(index, len(level_list)),
			"selection_index": current_index
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



# convert integer to roman numeral string
# https://www.geeksforgeeks.org/converting-decimal-number-lying-between-1-to-3999-to-roman-numerals/
func integerToRoman(num: int) -> String:
	# Storing roman values of digits from 0-9 
	# when placed at different places
	var m = [ "", "M", "MM", "MMM" ]
	var c = [ "", "C", "CC", "CCC", "CD", "D", 
		   "DC", "DCC", "DCCC", "CM "]
	var x = [ "", "X", "XX", "XXX", "XL", "L", 
		   "LX", "LXX", "LXXX", "XC" ]
	var i = [ "", "I", "II", "III", "IV", "V", 
		   "VI", "VII", "VIII", "IX"]
		  
	# Converting to roman
	var thousands = m[num / 1000]
	var hundereds = c[(num % 1000) / 100]
	var tens =  x[(num % 100) / 10]
	var ones = i[num % 10]
		  
	var ans = (thousands + hundereds +
				 tens + ones)
		  
	return ans;

func open_selected_level():
	if current_index == 0:
		SceneLoader.goto_scene("res://scenes/level_editor/CustomLevelsManager.tscn")
	else:
		var level = $Center.get_child(current_index)
		if level.level_data["state"] != level_selection.LevelState.LOCKED:
			SceneLoader.goto_scene("res://scenes/Game.tscn", {
				"selection_index": current_index,
				"level_path": level.level_data["level_path"],
				"next_levels": level.level_data["next_levels"],
				"god": god
			})
		else:
			SoundEngine.play_sound("Whoosh")


func _on_LevelSelectionItem_selected(index):
	if index == current_index:
		open_selected_level()
	else:
		self.current_index = index


func _set_current_index(new_index: int):
	current_index = new_index
	get_tree().call_group("levels", "_set_current_index", current_index)
	SoundEngine.play_sound("MoonThrowing")

func set_god(current_god: String):
	god = current_god
