extends Area2D

var type = "Planet"
var global_hue = 0.5
onready var cloud = $Cloud
onready var cloud2 = $Cloud2


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	set_hue(randf())
	set_seed(rand_range(0, 10))

func set_pixels(amount):
	cloud.material.set_shader_param("pixels", amount)
	cloud2.material.set_shader_param("pixels", amount)

func set_light(pos):
	cloud.material.set_shader_param("light_origin", pos)
	cloud2.material.set_shader_param("light_origin", pos)

func set_seed(sd):
	var converted_seed = sd
	cloud.material.set_shader_param("seed", converted_seed)
	cloud2.material.set_shader_param("seed", converted_seed)
	cloud2.material.set_shader_param("cloud_cover", rand_range(0.28, 0.5))


func set_hue(h):
	var hue = h
	
	# set hue for first cloud layer
	var cloud_basec = cloud.material.get_shader_param("base_color")
	var cloud_shadow = cloud.material.get_shader_param("shadow_outline_color")
	cloud_basec.h = hue
	cloud_shadow.h = hue
	cloud.material.set_shader_param("base_color", cloud_basec)
	cloud.material.set_shader_param("shadow_outline_color", cloud_shadow)
	
	# set hue for second cloud layer
	var cloud2_basec = cloud2.material.get_shader_param("base_color")
	var cloud2_outline = cloud2.material.get_shader_param("outline_color")
	var cloud2_shadow = cloud2.material.get_shader_param("shadow_outline_color")
	var cloud2_shadow_base = cloud2.material.get_shader_param("shadow_base_color")
	var hue_mod = rand_range(0, 3)
	cloud2_basec.h = hue*hue_mod
	cloud2_shadow.h = hue*hue_mod
	cloud2_outline.h = hue*hue_mod
	cloud2_shadow_base.h = hue*hue_mod
	cloud2.material.set_shader_param("base_color", cloud2_basec)
	cloud2.material.set_shader_param("outline_color", cloud2_outline)
	cloud2.material.set_shader_param("shadow_base_color", cloud2_shadow_base)
	cloud2.material.set_shader_param("shadow_outline_color", cloud2_shadow)


func _on_Planet_body_entered(body):
	if body.has_method("explode"):
		body.explode()
