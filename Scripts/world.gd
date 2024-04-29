extends Node2D
@onready var pause_menu = $Player/Camera2D/PauseMenu
@onready var player = $Player
@onready var ui = $InvCanvas/UI
@onready var battle = $BattleCanvas/Battle

var FileData: FileSave
var save_file_path = "user://save/"
var save_file_name = "Player.tres"
var paused = false


func _ready() -> void:
	WorldSignals.battle_start.connect(battle_begin)
	WorldSignals.position_load.connect(lload)
	WorldSignals.battle_end.connect(battle_ends)
	ssave_or_lload()
	await LevelTransition.fade_out()
	LevelTransition.hide()

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
	battle.start()
	battle.show()
	
func battle_ends():
	reload_child_scene()
	

	
func ssave_or_lload():
	if WorldSignals.use_load:
		FileData = FileSave.lload()
		WorldSignals.use_load = false
	else:
		FileData = FileSave.new()
		FileData.global_position = player.global_position
		ssave()
		
	player.position = FileData.global_position
	
func reload_child_scene():
	var child_scene_path = "res://Scenes/battle.tscn"
	var child_scene_resource = load(child_scene_path)
	if child_scene_resource:
		var old_child_scene = battle
		var new_child_scene = child_scene_resource.instantiate()
		old_child_scene.get_parent().add_child(new_child_scene)
		old_child_scene.queue_free()
		new_child_scene.hide()
		battle = new_child_scene
	else:
		OS.alert("Failed to load the child scene resource.")
		
func lload():
	FileData = FileSave.lload()
	player.position = FileData.global_position
	
func ssave():
	FileData.global_position = player.position
	FileData.ssave()
	
	print("saved:")
	print(FileData.global_position)
	print(FileData.playerData.health)
