extends Node2D

@onready var pause_menu = $Player/Camera2D2/PauseMenu
@onready var player = $Player

var playerData = FileSave.playerData
var save_file_path = "user://save/"
var save_file_name = "Player.tres"

var paused = false


func _ready():
	if ( ResourceLoader.exists( save_file_path + save_file_name ) ):
		lload()
	WorldSignals.battle_start.connect(battle_begin)
	WorldSignals.position_load.connect(lload)
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	playerData.UpdatePos(player.position)
	
	
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused

func battle_begin():
	print("area has entered, prepare for battle!")
	ssave()
	await (get_tree().create_timer(1.0).timeout)
	get_tree().change_scene_to_file("res://Scenes/battle.tscn")
	
func lload():
	playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	player.position = playerData.global_position
	print("loaded:")
	print(playerData.global_position)
	
func ssave():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("saved:")
	print(playerData.global_position)
	print(playerData.health)
	


func _on_chat_area_body_entered(body):
	if Input.is_action_just_pressed("ui_accept"):
		DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/test.dialogue"), "start")
		return
