extends Area2D
@onready var chat_area = $ChatArea
@onready var d_uh = $".."

func _on_body_entered(body):
	if chat_area.is_in_area == true:
		chat_area.d_balloon()
		chat_area.dialogue_opened = true
		WorldSignals.in_dialogue = true
		print("does it work")
