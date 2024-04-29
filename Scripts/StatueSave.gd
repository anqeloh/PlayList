extends Control
signal textbox_closed

@onready var world = $"../.."
@onready var textbox = $BottomSave/Textbox
@onready var player_info_label = $TopSave/PlayerInfoLabel
@onready var save_button = $BottomSave/SaveButton

var _fileDT 

var pH
var pA
var pL

func _ready() -> void:
	WorldSignals.save.connect(open_save)
	_fileDT = world.FileData

func open_save():
	await (get_tree().create_timer(0.15).timeout)
	save_button.show()
	self.visible = true
	display_text("Would You Like to Save?")
	
func display_text(text):
	textbox.text = text
	
func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and textbox.visible:
		textbox_closed.emit()


func _on_save_button_pressed():
	await ssave()
	save_button.hide()
	display_text("Your game has been saved.")
	await self.textbox_closed
	await (get_tree().create_timer(0.15).timeout)
	self.visible = false
	OS.alert("09483v934hnh9t54t5454h8tfg54h78rujhfguyjhwefgwe")
func ssave():
	world.ssave()

func up_stats():
	pH = _fileDT.playerData.health
	pA = _fileDT.playerData.damage
	pL = _fileDT.playerData.level
	player_info_label.text = "Stats:
	HTH: %d
	ATK: %d
	LVL: %d" % [pH, pA, pL]
	
