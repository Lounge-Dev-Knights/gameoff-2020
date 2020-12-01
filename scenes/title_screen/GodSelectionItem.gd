extends Node2D


signal selected
signal show_god_preview


var index = 0
var current_index = 0 setget _set_current_index

var offset_1 = 100
var offset_2 = 200

var scale_1 = 0.8
var scale_2 = 0.4
var scale_full = 1.5


onready var tag = $HBoxContainer
onready var name_label = $HBoxContainer/Name
onready var god = $God
onready var sprite = $God/Sprite
onready var god_collision = $God/CollisionShape2D


enum State {
	LOCKED,
	UNLOCKED
}

var god_data = {
	"name": "Fortuna",
	"state": State.UNLOCKED,
	"sprite": null,
	"stars_needed": 0
}


onready var tween = $Tween


func _ready():

	# set god label
	name_label.text = god_data["name"]
	# set text color to black
	name_label.add_color_override("font_color", Color(0,0,0,1))
	
	# set sprite
	var god_image = god_data['sprite']
	sprite.texture = god_image
	if god_data["state"] == State.LOCKED:
		name_label.text = "Need " + str(god_data["stars_needed"]) + " more Stars"
		sprite.modulate = Color(0,0,0,1)
		$HBoxContainer/Preview.hide()

	get_tree().connect("screen_resized", self, "_on_screen_resized")
	_on_screen_resized()



func _on_screen_resized():
	self.current_index = current_index



func _set_current_index(new_index):
	current_index = new_index
	
	tween.stop_all()

	
	if current_index == index - 2:
		tween.interpolate_property(self, "position", position, Vector2(-offset_1, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.6), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(god, "scale", god.scale, Vector2(scale_1, scale_1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tag.hide()
		tag.mouse_filter = Control.MOUSE_FILTER_PASS	
	elif current_index == index - 1:
		tween.interpolate_property(self, "position", position, Vector2(offset_1, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.6), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(god, "scale", god.scale, Vector2(scale_1, scale_1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tag.hide()
		tag.mouse_filter = Control.MOUSE_FILTER_PASS
	elif current_index == index:
		tween.interpolate_property(self, "position", position, Vector2(), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 1.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(god, "scale", god.scale, Vector2(scale_full, scale_full), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tag.show()
		tag.mouse_filter = Control.MOUSE_FILTER_PASS
	elif current_index == index + 1:
		tween.interpolate_property(self, "position", position, Vector2(-offset_1, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.6), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(god, "scale", god.scale, Vector2(scale_1, scale_1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tag.mouse_filter = Control.MOUSE_FILTER_PASS
		tag.hide()
	elif current_index == index + 2:
		tween.interpolate_property(self, "position", position, Vector2(offset_1, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.6), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(god, "scale", god.scale, Vector2(scale_1, scale_1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tag.mouse_filter = Control.MOUSE_FILTER_PASS
		tag.hide()
	
	if current_index == index:
		z_index = 6
	else:
		z_index = 5
	
	tween.start()



func _on_God_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		var mouse_event = (event as InputEventMouseButton)
		if mouse_event.pressed and mouse_event.button_index == BUTTON_LEFT:
			emit_signal("selected")


func _on_ToolButton_pressed():
	emit_signal("show_god_preview")
