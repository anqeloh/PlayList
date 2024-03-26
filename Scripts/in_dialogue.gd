extends Node2D

const BALLOON = preload("res://Dialogues/balloon.tscn")
@export var dialogue_insert: DialogueResource
@export var dialouge_start: String = "start"

var is_in_area = false
var dialogue_opened = false

func _ready():
	WorldSignals.dialogue_finished.connect(dialogue_finished)
func _area_entered(body):
	is_in_area = true

func _process(delta):
	if is_in_area == true:
		if not dialogue_opened:
			if Input.is_action_just_pressed("chat"):
				d_balloon()
				dialogue_opened = true
				
func _on_body_exited(body):
	is_in_area = false

func d_balloon() -> void:
	var balloon: Node = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_insert, dialouge_start)

func dialogue_finished():
	dialogue_opened = false
