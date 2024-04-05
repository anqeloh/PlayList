extends Node

signal experience_gained(growth_data)

# CHARACTER STATS
@export var max_hp = 12
@export var strength = 8
@export var magic = 8
@export var defense = 5

# LEVELING SYSTEM
@export var level = 1

var experience = 0
var experience_total = 0
var experience_required = get_required_experience(level + 1)

func get_required_experience(level):
	return round(pow(level, 1.8) + level * 4)

func gain_experience(amount):
	experience_total += amount
	experience += amount
	var growth_data = []
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required, experience_required])
		level_up()
	growth_data.append([experience, experience_required])
	emit_signal("experience_gained", growth_data)

func level_up():
	level += 1
	experience_required = get_required_experience(level + 1)

	max_hp += 20
	strength += 5
	magic += 5
	defense += 2
