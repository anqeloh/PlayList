extends Node

signal battle_start
signal position_load
signal dialogue_finished
signal experience_gained(growth_data)
signal item_collect
signal save

var player_in_chat_zone = false
var in_dialogue = false
var use_load = false
