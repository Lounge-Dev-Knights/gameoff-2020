tool
extends CenterContainer


func _ready():
	randomize()
	get_viewport().connect("size_changed", self, "_viewport_size_changed")
	_viewport_size_changed()
	
	if OS.has_feature("HTML5"):
		($Background.material as ShaderMaterial).set_shader_param("threshold", 0.75)



func _viewport_size_changed():
	var rect = get_rect()
	$Background.texture = _get_noise_texture(rect.size)
	$BlinkingStars/CPUParticles2D.emission_rect_extents = rect.size / 2


func _get_noise_texture(size: Vector2):
	
	var noise = OpenSimplexNoise.new()
	noise.octaves = 2
	noise.period = 4
	noise.persistence = 1
	noise.lacunarity = 4
	noise.seed = randi()
	
	var texture: NoiseTexture = NoiseTexture.new()
	
	texture.noise = noise
	texture.width = size.x
	texture.height = size.y
	
	return texture
