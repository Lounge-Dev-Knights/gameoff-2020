extends Area2D


var index = 0
var current_index = 0 setget _set_current_index

var offset_1 = 200
var offset_2 = 400

var scale_1 = 0.7
var scale_2 = 0.3

var level_name = "Level 1"

onready var tween = $Tween


func _ready():
	$Label.text = level_name
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
		$CollisionShape2D.set("disabled", true)
	elif current_index == index - 1:
		tween.interpolate_property(self, "position", position, Vector2(offset_1, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.3), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_1, scale_1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$CollisionShape2D.set("disabled", false)
	elif current_index == index:
		tween.interpolate_property(self, "position", position, Vector2(), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 1.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(1.0, 1.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$CollisionShape2D.set("disabled", false)
	elif current_index == index + 1:
		tween.interpolate_property(self, "position", position, Vector2(-offset_1, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.3), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_1, scale_1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$CollisionShape2D.set("disabled", false)
	elif current_index >= index + 2:
		tween.interpolate_property(self, "position", position, Vector2(-offset_2, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2(scale_2, scale_2), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$CollisionShape2D.set("disabled", true)
	
	
	if current_index == index:
		$Constellation.show_lines()
		z_index = 0
	else:
		$Constellation.hide_lines()
		z_index = -1
	
	tween.start()

