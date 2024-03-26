extends Node2D

const Balloon = preload("res://Dialogues/balloon.tscn")
@export var dialogue_insert: DialogueResource
@export var dialouge_start: String = "start"
var is_in_area = false


func _area_entered(body):
	is_in_area = true

func _process(delta):
	if is_in_area == true:
		if Input.is_action_just_pressed("chat"):
			DialogueManager.show_example_dialogue_balloon(dialogue_insert, dialouge_start)
func _on_body_exited(body):
	is_in_area = false

func d_balloon():
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	Balloon.start(dialogue_insert, dialouge_start)
