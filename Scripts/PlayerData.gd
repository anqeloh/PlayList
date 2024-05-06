extends Resource
class_name PlayerData


@export var health = 25
@export var damage = 5
@export var AbilityPower = 10
@export var level: int = 1
@export var max_health = 25
@export var strength = 8
@export var magic = 8
@export var defense = 5
var player_strength_INC

@export var experience = 0
@export var experience_rq = 0
var experience_total = 0


func change_health(value :int):
	health += value
	

func level_up():
	level += 1
	experience_rq = get_required_experience(level + 1)
	var stats = ['max_health', 'damage']
	max_health += 10
	strength += 5
	magic += 5
	defense += 2
	
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

func player_stat_increase():
	player_strength_INC = strength * 2
