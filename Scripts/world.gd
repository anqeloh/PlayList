extends Node2D

@onready var pause_menu = $Player/PauseMenu
@onready var battle_start = $BattleStart

var paused = false
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
	
	
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused




func _on_battle_start_area_entered(area):
	get_tree().change_scene_to_file("res://Scenes/battle.tscn")
