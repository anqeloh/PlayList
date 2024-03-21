extends Node2D

var player

func _area_entered(body):
	if body.has_method("player"):
		player = body
		WorldSignals.player_in_chat_zone = true
	
func _area_exited(body):
	if body.has_method("player"):
		WorldSignals.player_in_chat_zone = false
	
func in_dialogue():
	pass

