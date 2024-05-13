shader_type canvas_item;

// noise texture
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
// fog density
uniform float density: hint_range(0.0, 1.0) = 0.25;
// fog speed
uniform vec2 speed =  vec2(0.02, 0.01);

void fragment() {
	// make the fog slowly move
	vec2 uv  = UV + speed * TIME;
	// sample the noise texure
	float noise = texture(noise_texture, UV).r;
	// convert the noise from the (0.0 - 1.0) range to the (-1.0 , 1.0) range
	// clamp it between 0.0 to 1.0 again again
	float fog = clamp(noise * 2.0 - 1.0, 0.0, 1.0);
	// apply the fog effect
	COLOR.a *= fog * density;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
