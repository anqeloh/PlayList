class_name FileSave

@export var playerData = PlayerData.new()
@export var world_position:= Vector2.ZERO

const SAVE_FILE_PATH = "user://save/"
const SAVE_FILE_NAME = "Player.tres"
var fileExists = true

func _ready():
	verify_save_directory(SAVE_FILE_PATH)
	
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
	

func save_exists():
	if not ( ResourceLoader.exists( SAVE_FILE_PATH + SAVE_FILE_NAME ) ):
		fileExists = false

func ssave() -> void:
	ResourceSaver.save(self, SAVE_FILE_PATH + SAVE_FILE_NAME)
	
static func lload() -> Resource:
	var save_pth :String = SAVE_FILE_PATH + SAVE_FILE_NAME
	if  ResourceLoader.exists(save_pth):
		return ResourceLoader.load(SAVE_FILE_PATH + SAVE_FILE_NAME).duplicate(true)
	else:
		return null
