extends Area2D

const type = "Planet"


const COLORS = [
	Color.cyan,
	Color.magenta,
	Color.fuchsia,
	Color.aquamarine,
	Color.honeydew,
	Color.salmon
]


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = COLORS[randi() % COLORS.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
