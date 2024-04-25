extends Control

var save_file_path = "user://save/"
var save_file_name = "Player.tres"

func _ready():
	LevelTransition.show()
	await LevelTransition.fade_out()
	LevelTransition.hide()

func _on_story_pressed():
	if not ( ResourceLoader.exists( save_file_path + save_file_name ) ):
		LevelTransition.show()
		await LevelTransition.fade_in()
		get_tree().change_scene_to_file("res://Scenes/world.tscn")
		
	else: 
		LevelTransition.show()
		await LevelTransition.fade_in()
		DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/FileOverrideWarning.dialogue"), "start")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_load_pressed():
	if ( ResourceLoader.exists( save_file_path + save_file_name ) ):
		WorldSignals.use_load = true
		LevelTransition.show()
		await LevelTransition.fade_in()
		get_tree().change_scene_to_file("res://Scenes/world.tscn")
	else:
		print("no loaded file")
		return

