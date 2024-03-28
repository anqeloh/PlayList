extends Node
@onready var _stat = $"../Player/Stat"
@onready var _label =  $"../Label"

func _ready():
	_label.update_text(_stat.level, _stat.experience, _stat.experience_required)

func _input(event):
	if not event.is_action_pressed("ui_accept"):
		return
	_stat.gain_experience(50)
	_label.update_text(_stat.level, _stat.experience, _stat.experience_required)
