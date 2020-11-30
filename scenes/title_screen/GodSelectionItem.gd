extends Node2D


signal selected


var index = 0
var current_index = 0 setget _set_current_index

var offset_1 = 100
var offset_2 = 200

var scale_1 = 0.7
var scale_2 = 0.3


onready var name_label = $God/Name
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
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	_on_screen_resized()



func _on_screen_resized():
	self.current_index = current_index



func _set_current_index(new_index):
	current_index = new_index
	
	tween.stop_all()	

		
	if current_index <= index - 2:
		tween.interpolate_property(self, "position", position, Vector2(offset_2, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_2, scale_2), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	elif current_index == index - 1:
		tween.interpolate_property(self, "position", position, Vector2(offset_1, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.3), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_1, scale_1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		name_label.mouse_filter = Control.MOUSE_FILTER_PASS
	elif current_index == index:
		tween.interpolate_property(self, "position", position, Vector2(), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 1.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(1.0, 1.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		name_label.mouse_filter = Control.MOUSE_FILTER_PASS
	elif current_index == index + 1:
		tween.interpolate_property(self, "position", position, Vector2(-offset_1, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.3), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_1, scale_1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		name_label.mouse_filter = Control.MOUSE_FILTER_PASS
	elif current_index >= index + 2:
		tween.interpolate_property(self, "position", position, Vector2(-offset_2, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_2, scale_2), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
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
