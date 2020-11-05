extends Node2D

# how far can an object be dragged
const DRAG_DISTANCE = 150
const MODULATE_COLOR = Color(0.503906, 0.503906, 0.503906)

# how many times can you drag
var drags_left: int = 1
# the currently hovered object
var hovered_object: Node2D = null
# the currently dragged object
var drag_object: Node2D = null
# origin of the currently dragged object
var drag_origin: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	for object in get_tree().get_nodes_in_group("objects"):
		object.connect("mouse_entered", self, "_on_object_mouse_entered", [object])
		object.connect("mouse_exited", self, "_on_object_mouse_exited", [object])
		

func _physics_process(delta):
	if drag_object != null:
		var drag_offset = get_global_mouse_position() - drag_origin
		drag_object.position = drag_origin + drag_offset.clamped(DRAG_DISTANCE)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and hovered_object != null and drags_left > 0:
			drags_left -= 1
			drag_object = hovered_object
			drag_origin = drag_object.position
		elif drag_object != null:
			drag_object = null


func _on_object_mouse_entered(object):
	hovered_object = object
	object.modulate += MODULATE_COLOR


func _on_object_mouse_exited(object):
	object.modulate -= MODULATE_COLOR
	if hovered_object == object:
		hovered_object = null
