extends Control

var save_file_path = "user://save/"
var save_file_name = "Player.tres"

func _on_story_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_load_pressed():
	if ( ResourceLoader.exists( save_file_path + save_file_name ) ):
		get_tree().change_scene_to_file("res://Scenes/world.tscn")
		WorldSignals.use_load = true
	else:
		print("no loaded file")
		return
