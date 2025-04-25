shader_type canvas_item;

uniform sampler2D noise1: repeat_enable;
uniform sampler2D noise2: repeat_enable;
uniform vec2 scroll1 = vec2(0.05, 0.05);
uniform vec2 scroll2 = vec2(-0.05, -0.05);
uniform sampler2D screen_text: hint_screen_texture;
uniform float dist_strength : hint_range(-1, 1) = 0.2;
uniform vec4 tone_color: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float depth = texture(noise1, UV + scroll1 * TIME).r * texture(noise2, UV + scroll2 * TIME).r;
	//vec4 noise_col = texture(noise, UV + scroll * TIME);
	vec4 screen_col = texture(screen_text, SCREEN_UV + dist_strength * vec2(depth));
	COLOR = screen_col * tone_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
