extends ParallaxLayer

# Speed at which this layer scrolls
var scroll_speed = 100.0

func _process(delta):
	var offset = motion_offset
	offset.x += scroll_speed * delta
	# Wrap the offset to keep it within the texture bounds
	if get_node("Sprite").texture:
		var texture_width = get_node("Sprite").texture.get_size().x
		offset.x = fmod(offset.x, texture_width)
	motion_offset = offset
