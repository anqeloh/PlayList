extends Control

func _input(event):
	if event.is_action_pressed("InvButton"):
		visible = !visible
