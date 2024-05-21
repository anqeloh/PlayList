extends Node

@export var world_position:= Vector2.ZERO
var FileData = FileSave.new()
const SAVE_FILE_PATH = "user://save/"
const SAVE_FILE_NAME = "Player.tres"

func ssave() -> void:
	ResourceSaver.save(FileData, SAVE_FILE_PATH + SAVE_FILE_NAME)
	
func lload() -> Resource:
	var save_pth :String = SAVE_FILE_PATH + SAVE_FILE_NAME
	if  ResourceLoader.exists(save_pth):
		return ResourceLoader.load(SAVE_FILE_PATH + SAVE_FILE_NAME).duplicate(true)
	else:
		return null
