extends Node2D

@onready var pause_menu = $Player/Camera2D/PauseMenu
@onready var player = $Player
@onready var ui = $InvCanvas/UI

var playerData = FileSave.playerData
var save_file_path = "user://save/"
var save_file_name = "Player.tres"

var paused = false


func _ready():
	WorldSignals.battle_start.connect(battle_begin)
	WorldSignals.position_load.connect(lload)
	if WorldSignals.use_load:
		lload()
		WorldSignals.use_load = false
	await LevelTransition.fade_out()
	LevelTransition.hide()
	
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
	
