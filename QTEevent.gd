extends Node2D

@onready var bar = $QTEbar
@onready var arrow = $QTEarrow

func _ready():
	set_process_input(true)  # Make sure the node processes input events

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Call this when the player clicks
		check_if_arrow_in_target()

func check_if_arrow_in_target():
	var bar_position = bar.global_position.x
	var bar_width = bar.rect_size.x  # Change accordingly if not a Contr
func get_target_section_bounds(bar_position, bar_width):
	var center_start = bar_position + bar_width / 3  # Start of the center third
	var center_end = bar_position + 2 * bar_width / 3  # End of the center third
	
