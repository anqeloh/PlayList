extends CanvasLayer

@onready var inv: INV= preload("res://Resource/PlayerInv.tres")
@onready var slots: Array = $InvUI/NinePatchRect/GridContainer.get_children()
var save_file_path = "user://save/"
var save_file_name = "Player.tres"
var is_open = false

func _ready():
	#if ( ResourceLoader.exists( save_file_path + save_file_name ) ):
		#lload()
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])


func _process(delta):
	if Input.is_action_just_pressed("test_button"):
		if is_open:
			close()
		else:
			open()

func open():
	self.visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
	
func lload():
	inv = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
