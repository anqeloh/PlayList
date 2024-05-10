extends Node2D

@onready var bar = $QTEbar
@onready var arrow = $QTEarrow
@onready var tween = create_tween().set_loops()
var is_in_area = false
var SPEED = 15
#352.0px and 44 units = length of bar

func _ready():
	set_process_input(true)  # Make sure the node processes input events
	#tween.tween_property(arrow, "position:x", 340.0, 1).as_relative()
	#tween.tween_property(arrow, "position:x", -345.0, 1).as_relative()
	
func _process(delta):
	arrow.position.x += SPEED
	speed_check()
	
func _input(event):
	if Input.is_action_just_pressed("ui_accept") and is_in_area:
		print("correct")

func _on_qt_eredarea_body_entered(body):
	is_in_area = true
	

func _on_qt_eredarea_body_exited(body):
	is_in_area = false

func speed_check():
	if arrow.position.x >= 752:
		SPEED = -15
		print(arrow.position.x)
	if arrow.position.x <= 400:
		SPEED = 15
		print(arrow.position.x)
