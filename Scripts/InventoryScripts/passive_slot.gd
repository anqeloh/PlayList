extends Slot

class_name PassiveSlot

func _can_drop_data(at_position, data):
	return data is TextureRect and data.slot_type == slot_type
	
