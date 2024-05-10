extends Node2D

@onready var bar = $QTEbar
@onready var arrow = $QTEarrow
var is_in_area = false
var SPEED = 20
#352.0px and 44 units = length of bar
func _process(delta):
	arrow.position.x += SPEED
	speed_check()
	
func _input(event):
	if Input.is_action_just_pressed("spaceBUTTON") and is_in_area:
		WorldSignals.QTE.emit()
	elif Input.is_action_just_pressed("spaceBUTTON"):
		print("LOSE")
		OS.alert("You Lose!")
		get_tree().quit()

func _on_qt_eredarea_body_entered(body):
	is_in_area = true
	

func _on_qt_eredarea_body_exited(body):
	is_in_area = false

func speed_check():
	if arrow.position.x >= 752:
		SPEED = -SPEED
	if arrow.position.x <= 400:
		SPEED = -SPEED
