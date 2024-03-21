extends Node

var save_file_path = "user://save/"
var save_file_name = "Player.tres"
var playerData = PlayerData.new()

func _ready():
	verify_save_directory(save_file_path)
	
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
