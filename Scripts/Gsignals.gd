extends Node

signal battle_start
signal battle_end
signal position_load
signal dialogue_finished
signal experience_gained(growth_data)
signal item_collect
signal save
signal collect_stats

var player_in_chat_zone = false
var in_dialogue = false
var use_load = false
