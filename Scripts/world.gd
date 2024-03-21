extends Node2D

@onready var pause_menu = $Player/Camera2D/PauseMenu
@onready var battle_start = $BattleStart

var paused = false
func _ready():
	WorldSignals.battle_start.connect(battle_begin)
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

func battle_begin():
	print("area has entered, prepare for battle!")
	await (get_tree().create_timer(1.0).timeout)
	get_tree().change_scene_to_file("res://Scenes/battle.tscn")
