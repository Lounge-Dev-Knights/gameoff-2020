extends Control


var current_index = 1 setget _set_current_index
var progress_path = "user://progress.json"

var stars = 0


const STARS_FOR_MARS = 10
const STARS_FOR_JUPITER = 20

var fortuna_sprite = preload("res://scenes/gods/fortuna.png")
var mars_sprite = preload("res://scenes/gods/mars.png")
var jupiter_sprite = preload("res://scenes/gods/jupiter.png")

var gods = Array()
var god_selection

func load_total_stars():
	var file = File.new()
	file.open(progress_path, File.READ)
	var progress = parse_json(file.get_as_text())
	file.close()

	var total_stars_count = 0
	if progress == null:
		return 0
	for i in progress.values():
		if i.has("stars_collected"):
			total_stars_count += len(i["stars_collected"])
	return total_stars_count
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	
	stars = load_total_stars()
	
	# load Mars first
	god_selection = preload("res://scenes/title_screen/GodSelectionItem.tscn").instance()
	god_selection.index = index
	var state = god_selection.State.LOCKED if stars < STARS_FOR_MARS else god_selection.State.UNLOCKED
	#var state = god_selection.State.UNLOCKED
	
	
	gods.append({
		"name": "Mars",
		"state": state,
		"sprite": mars_sprite,
		"stars_needed": STARS_FOR_MARS - stars
	})
	
	god_selection.god_data = gods[index]
	god_selection.connect("selected", self, "_on_GodSelectionItem_selected", [index])
	$Center.add_child(god_selection)
	
	# load Fortuna
	index += 1
	god_selection = preload("res://scenes/title_screen/GodSelectionItem.tscn").instance()
	god_selection.index = index
	#var state = god_selection.State.LOCKED if stars < STARS_FOR_MARS else god_selection.State.LOCKED
	state = god_selection.State.UNLOCKED
	
	
	gods.append({
		"name": "Fortuna",
		"state": state,
		"sprite": fortuna_sprite,
		"stars_needed": 0
	})
	
	god_selection.god_data = gods[index]
	god_selection.connect("selected", self, "_on_GodSelectionItem_selected", [index])
	$Center.add_child(god_selection)
	
	# load Jupiter
	index += 1
	god_selection = preload("res://scenes/title_screen/GodSelectionItem.tscn").instance()
	god_selection.index = index
	state = god_selection.State.LOCKED if stars < STARS_FOR_JUPITER else god_selection.State.LOCKED
	#state = god_selection.State.UNLOCKED

	
	gods.append({
		"name": "Jupiter",
		"state": state,
		"sprite": jupiter_sprite,
		"stars_needed": STARS_FOR_JUPITER - stars
	})
	
	god_selection.god_data = gods[index]
	god_selection.connect("selected", self, "_on_GodSelectionItem_selected", [index])
	$Center.add_child(god_selection)
	
	
func _on_GodSelectionItem_selected(index):
	if index == current_index:
		set_god()
	else:
		self.current_index = index

func set_god():
	var god = gods[current_index]
	if god["state"] == god_selection.State.UNLOCKED:
		get_tree().call_group("level_select", "set_god", god["name"])


func _set_current_index(new_index: int):
	current_index = new_index
	get_tree().call_group("god_select", "_set_current_index", current_index)
	set_god()
	SoundEngine.play_sound("MoonThrowing")
