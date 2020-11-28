extends Node2D

const constellations = {
	"editor": {
		"stars": [
			Vector2(-102, 96),
			Vector2(-49, 95),
			Vector2(20, 15),
			Vector2(84, -61),
			Vector2(81, -78),
			Vector2(45, -107),
			Vector2(17, -103),
			Vector2(-40, -43),
			Vector2(-109, 28),
			Vector2(-22, -20),
			Vector2(0, -5),
			Vector2(-92, 44),
			Vector2(-61, 65),
			Vector2(60, -75),
			Vector2(30, -88),
		],
		"collected": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
		"connections": [
			[0, 1],
			[1, 2],
			[2, 3],
			[3, 4],
			[4, 5],
			[5, 6],
			[6, 7],
			[7, 8],
			[8, 0],
			[1, 12],
			[12, 11],
			[11, 8],
			[3, 13],
			[13, 14],
			[14, 6],
			[11, 9],
			[12, 10],
			[10, 13],
			[9, 14],
		]
	},
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
		"collected": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
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


var collected = []


var stars = []


onready var tween = $Tween




func _draw():
	for star in stars:
		# fill out collected stars
		if stars.find(star) in collected:
			#draw_circle(star, 6, Color.white)
			var texture = preload("res://scenes/title_screen/star.png")
			
			var pos = star - Vector2(texture.get_width(), texture.get_height()) / 2
			draw_texture(preload("res://scenes/title_screen/star.png"), pos)
		else:
			draw_arc(star, 6, 0, 2 * PI, 30, Color.white, 1, true)


func load_constellation(constellation: Dictionary) -> void:
	for star in constellation["stars"]:
		stars.append(star)
		
	collected = constellation["collected"]
	
	for connection in constellation["connections"]:
		
		if connection[0] in constellation["collected"] and connection[1] in constellation["collected"]:
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
			line.width = 2
			$lines.add_child(line)
	
	update()


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
	update()


func load_procedural(collected_stars: Array, max_stars: int, constellation_seed: int):
	var rng = RandomNumberGenerator.new()
	for i in range(max_stars):
		stars.append(Vector2(rng.randf_range(-150, 150), rng.randf_range(-150, 150)))
	
	collected = collected_stars
	
	if max_stars > 1:
		for i in range(max_stars):
			var from_index = i
			var to_index = rng.randi() % stars.size()
			
			while to_index == from_index:
				to_index = rng.randi() % stars.size()
			
			if from_index in collected_stars and to_index in collected_stars:
				
				var from = stars[from_index]
				var to = stars[to_index]
				
				
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

func show_lines():
	tween.stop_all()
	for line in $lines.get_children():
		tween.interpolate_property(line, "scale", line.scale, Vector2(1, 1), 1.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.0)
	tween.start()


func hide_lines():
	tween.stop_all()
	for line in $lines.get_children():
		tween.interpolate_property(line, "scale", line.scale, Vector2(0, 0), 1.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.0)
	tween.start()
