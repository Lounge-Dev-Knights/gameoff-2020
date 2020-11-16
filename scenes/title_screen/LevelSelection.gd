extends CenterContainer


var current_index = 0 setget _set_current_index

# Called when the node enters the scene tree for the first time.
func _ready():
	var custom_levels = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
	custom_levels.index = 0
	custom_levels.level_name = "Custom levels"
	custom_levels.connect("input_event", self, "_on_LevelSelectionItem_input_event", [0])
	$Center.add_child(custom_levels)
	
	for i in range(1, 10):
		var level = preload("res://scenes/title_screen/LevelSelectionItem.tscn").instance()
		level.index = i
		level.level_name = "Level %d" % (i)
		level.connect("input_event", self, "_on_LevelSelectionItem_input_event", [i])
		$Center.add_child(level)
	
	self.current_index = 1


func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_right") and current_index < $Center.get_child_count() - 1:
		self.current_index += 1
	if Input.is_action_just_pressed("ui_left") and current_index > 0:
		self.current_index -= 1

func _on_LevelSelectionItem_input_event(_viewport, event, _shape_idx, index):
	if event is InputEventMouseButton and event.is_pressed():
		self.current_index = index


func _set_current_index(new_index: int):
	current_index = new_index	
	get_tree().call_group("levels", "_set_current_index", current_index)
