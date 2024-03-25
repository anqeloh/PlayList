extends Node2D

var is_in_area = false
@export var dialogue_insert: DialogueResource

func _area_entered(body):
	is_in_area = true

func _process(delta):
	if is_in_area == true:
		if Input.is_action_just_pressed("chat"):
			DialogueManager.show_example_dialogue_balloon(dialogue_insert, "start")
func _on_body_exited(body):
	is_in_area = false
