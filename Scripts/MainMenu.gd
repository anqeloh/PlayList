extends Control

func _on_story_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()
