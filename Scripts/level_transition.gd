extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func fade_in():
	animation_player.play("Fade_in")
	await animation_player.animation_finished
	
func fade_out():
	animation_player.play("Fade_out")
	await animation_player.animation_finished
