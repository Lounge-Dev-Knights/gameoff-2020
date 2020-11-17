extends "res://scenes/objects/Planet.gd"

onready var craters = $Craters
onready var planet_under = $PlanetUnder


# Called when the node enters the scene tree for the first time.
func _ready():
	type = "TinyPlanet"
	set_hue(randf())


func set_pixels(amount):
	$PlanetUnder.material.set_shader_param("pixels", amount)
	$Craters.material.set_shader_param("pixels", amount)
func set_light(pos):
	$PlanetUnder.material.set_shader_param("light_origin", pos)
	$Craters.material.set_shader_param("light_origin", pos)

func set_seed(sd):
	var converted_seed = sd
	$PlanetUnder.material.set_shader_param("seed", converted_seed)
	$Craters.material.set_shader_param("seed", converted_seed)

