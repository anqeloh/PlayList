shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float light_intensity = 0.35;
	COLOR.rgb = texture(TEXTURE, UV).rgb * light_intensity;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
