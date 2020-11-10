shader_type canvas_item;
render_mode blend_mix;

uniform vec3 scale = vec3(1.0);

uniform vec3 albedo = vec3(1.0, 0.0, 0.0);
uniform float outline_width = 0.03;

void fragment() {
	if (texture(TEXTURE, UV).a < 0.5) {
		float alpha = 0.0;
		if (
			texture(TEXTURE, UV + vec2(0, -outline_width)).a != 0.0 ||
			texture(TEXTURE, UV + vec2(0, 0)).a != 0.0 ||
			texture(TEXTURE, UV + vec2(0, outline_width)).a != 0.0 ||
			texture(TEXTURE, UV + vec2(-outline_width, -outline_width)).a != 0.0 ||
			texture(TEXTURE, UV + vec2(-outline_width, 0)).a != 0.0 ||
			texture(TEXTURE, UV + vec2(-outline_width, outline_width)).a != 0.0 ||
			texture(TEXTURE, UV + vec2(outline_width, -outline_width)).a != 0.0 ||
			texture(TEXTURE, UV + vec2(outline_width, 0)).a != 0.0 ||
			texture(TEXTURE, UV + vec2(outline_width, outline_width)).a != 0.0
			) {
				alpha = 1.0
			}
		COLOR = vec4(albedo, alpha);
	}
	
}

