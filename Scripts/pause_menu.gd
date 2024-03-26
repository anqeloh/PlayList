extends Control

@onready var main = $"../../../.."


func _on_resume_pressed():
	main.pauseMenu()

func _on_quit_pressed():
	get_tree().quit()


func _on_save_pressed():
	main.save_pos()


func _on_load_pressed():
	main.player_pos()
