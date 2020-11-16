extends Node2D

var stars = []


onready var tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	
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
	
	
	update()


func _draw():
	for star in stars:
		if (randi() % 2) == 0:
			draw_circle(star, 4, Color.white)
		else:
			draw_arc(star, 4, 0, 2 * PI, 30, Color.white, 1, true)



func show_lines():
	tween.stop_all()
	for line in $lines.get_children():
		tween.interpolate_property(line, "scale", line.scale, Vector2(1, 1), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.5)
	tween.start()


func hide_lines():
	tween.stop_all()
	for line in $lines.get_children():
		tween.interpolate_property(line, "scale", line.scale, Vector2(0, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.5)
	tween.start()
