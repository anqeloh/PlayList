extends Resource
class_name PlayerData

@export var health = 100
var max_health = 100
@export var global_position: Vector2
@export var damage = 20

func change_health(value :int):
	health += value
	
func UpdatePos(value: Vector2):
	global_position = value
