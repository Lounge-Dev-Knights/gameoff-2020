extends Node2D

const constellations = {
	"locked": {
		"stars": [
			Vector2(-80, 120),
			Vector2(75, 125),
			Vector2(90, -50),
			Vector2(45, -55),
			Vector2(50, -80),
			Vector2(25, -109),
			Vector2(-25, -105),
			Vector2(-48, -85),
			Vector2(-50, -50),
			Vector2(-100, -50),
		],
		"connections": [
			[0, 1],
			[1, 2],
			[2, 3],
			[3, 4],
			[4, 5],
			[5, 6],
			[6, 7],
			[7, 8],
			[8, 9],
			[9, 0],
			[3, 8],
		]
	}
}

var stars = []


onready var tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	load_constellation(constellations["locked"])
	
	
	update()


func _draw():
	for star in stars:
		if (randi() % 2) == 0:
			draw_circle(star, 4, Color.white)
		else:
			draw_arc(star, 4, 0, 2 * PI, 30, Color.white, 1, true)


func load_constellation(constellation: Dictionary) -> void:
	for star in constellation["stars"]:
		stars.append(star)
	
	for connection in constellation["connections"]:
		var from = constellation["stars"][connection[0]]
		var to = constellation["stars"][connection[1]]
		
		var line = Line2D.new()
		line.position = from
		line.antialiased = true
		line.scale = Vector2()
		line.points = [
			Vector2(),
			to - from
		]
		line.default_color = Color.white
		line.width = 1
		$lines.add_child(line)


func load_random() -> void:
	for i in range(8):
		stars.append(Vector2(rand_range(-150, 150), rand_range(-150, 150)))
	
	for i in range(6):
		var from = stars[randi() % stars.size()]
		var to = stars[randi() % stars.size()]
		var line = Line2D.new()
		line.position = from
		line.antialiased = true
		line.scale = Vector2()
		line.points = [
			Vector2(),
			to - from
		]
		line.default_color = Color.white
		line.width = 1
		$lines.add_child(line)


func show_lines():
	tween.stop_all()
	for line in $lines.get_children():
		tween.interpolate_property(line, "scale", line.scale, Vector2(1, 1), 1.5, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	tween.start()


func hide_lines():
	tween.stop_all()
	for line in $lines.get_children():
		tween.interpolate_property(line, "scale", line.scale, Vector2(0, 0), 1.5, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	tween.start()
