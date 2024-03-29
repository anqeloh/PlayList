extends TextureProgressBar

func _ready():
	WorldSignals.connect("experience_gained", _on_character_experience_gained)
	

func initialize(current, maximum):
	max_value = maximum
	value = current

func animate_value(target, tween_duration = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'value', target, tween_duration)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	await tween.finished
	
	
func _on_character_experience_gained(growth_data):
	for line in growth_data:
		var target_experience = line[0]
		var max_experience = line[1]
		max_value = max_experience
		await animate_value(target_experience)
		if abs(max_value - value) < 0.01:
			value = 0
