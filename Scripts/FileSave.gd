extends Resource


const SAVE_FILE_PATH = "user://save/"
const SAVE_FILE_NAME = "Player.tres"
var fileExists = true

@export var health = 25
@export var damage = 5
@export var level: int = 1
@export var max_health = 25

@export var experience = 0
@export var experience_rq = 0
var experience_total = 0

#@export var Inventory = Inventory.new()
@export var global_position:= Vector2.ZERO

func _ready():
	verify_save_directory(SAVE_FILE_PATH)
	

func change_health(value :int):
	health += value
	

func level_up():
	level += 1
	experience_rq = get_required_experience(level + 1)
	var stats = ['max_health', 'damage']
	var random_stat = stats[randi() % stats.size()]
	set(random_stat, get(random_stat) + randi() % 4)
	
func get_required_experience(level):
	return round(pow(level, 1.8) + level * 4)
	
func gain_experience(amount):
	experience_total += amount
	experience += amount
	var growth_data = []
	while experience >= experience_rq:
		experience -= experience_rq
		growth_data.append([experience_rq, experience_rq])
		level_up()
	growth_data.append([experience, experience_rq])
	WorldSignals.emit_signal("experience_gained", growth_data)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
	
func UpdatePos(value: Vector2):
	global_position = value

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
