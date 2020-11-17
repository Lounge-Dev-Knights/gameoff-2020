extends Node2D


signal selected


var index = 0
var current_index = 0 setget _set_current_index

var offset_1 = 200
var offset_2 = 400

var scale_1 = 0.7
var scale_2 = 0.3


onready var labels = $Labels
onready var level_name = $Labels/Name
onready var state = $Labels/Status
onready var stars = $Labels/Stars

enum LevelState {
	LOCKED,
	UNLOCKED,
	COMPLETED
}

var level_data = {
	"name": "Level 1",
	"state": LevelState.LOCKED,
	"stars": 0,
	"stars_max": 8
}


onready var tween = $Tween


func _ready():
	level_name.text = level_data["name"]
	
	if level_data.has("state"):
		state.text = LevelState.keys()[level_data["state"]]
	else:
		state.hide()
	
	if level_data.has("stars"):
		stars.text = "%d/%d stars" % [level_data["stars"], level_data["stars_max"]]
	else:
		stars.hide()
	
	
	if not level_data.has("state"):
		$Constellation.load_constellation($Constellation.constellations["editor"])
	elif level_data["state"] == LevelState.LOCKED:
		$Constellation.load_constellation($Constellation.constellations["locked"])
	else:
		$Constellation.load_random()
	
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	_on_screen_resized()



func _on_screen_resized():
	offset_1 = get_viewport_rect().size.x / 4.0
	offset_2 = get_viewport_rect().size.x / 5.0
	self.current_index = current_index
	


func _set_current_index(new_index):
	current_index = new_index
	
	tween.stop_all()
	
	if current_index <= index - 2:
		tween.interpolate_property(self, "position", position, Vector2(offset_2, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_2, scale_2), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		labels.mouse_filter = Control.MOUSE_FILTER_IGNORE
	elif current_index == index - 1:
		tween.interpolate_property(self, "position", position, Vector2(offset_1, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.3), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_1, scale_1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		labels.mouse_filter = Control.MOUSE_FILTER_PASS
	elif current_index == index:
		tween.interpolate_property(self, "position", position, Vector2(), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 1.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(1.0, 1.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		labels.mouse_filter = Control.MOUSE_FILTER_PASS
	elif current_index == index + 1:
		tween.interpolate_property(self, "position", position, Vector2(-offset_1, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.3), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_1, scale_1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		labels.mouse_filter = Control.MOUSE_FILTER_PASS
	elif current_index >= index + 2:
		tween.interpolate_property(self, "position", position, Vector2(-offset_2, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_2, scale_2), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		labels.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	
	if current_index == index:
		$Constellation.show_lines()
		z_index = 6
	else:
		$Constellation.hide_lines()
		z_index = 5
	
	tween.start()



func _on_Labels_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("selected")
