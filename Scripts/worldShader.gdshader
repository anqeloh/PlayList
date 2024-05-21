shader_type canvas_item;

uniform float light_intensity = 0.35;

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR.rgb = texture(TEXTURE, UV).rgb * light_intensity;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
