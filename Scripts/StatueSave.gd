extends Control
signal textbox_closed

@onready var world = $"../.."
@onready var textbox = $BottomSave/Textbox
@onready var player_info_label = $TopSave/PlayerInfoLabel
@onready var save_button = $BottomSave/SaveButton
@onready var battle = $"../../BattleCanvas/Battle"

var fileData

func _ready() -> void:
	WorldSignals.save.connect(open_save)
	fileData = world.FileData

func open_save():
	await (get_tree().create_timer(0.15).timeout)
	save_button.show()
	up_stats()
	self.visible = true
	display_text("Would You like to save your point?")
	
func display_text(text):
	textbox.text = text
	
func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and textbox.visible:
		textbox_closed.emit()


func _on_save_button_pressed():
	fileData.playerData.change_health(fileData.playerData.max_health - fileData.playerData.health)
	await ssave()
	up_stats()
	save_button.hide()
	display_text("Your game has been saved.")
	await self.textbox_closed
	await (get_tree().create_timer(0.15).timeout)
	self.visible = false
	
func ssave():
	fileData.ssave()

func up_stats():
	var pH = fileData.playerData.health
	var pHH = fileData.playerData.max_health
	var pA = fileData.playerData.damage
	var pL = fileData.playerData.level
	player_info_label.text = "Stats:
	HTH: %d / %d
	ATK: %d
	LVL: %d" % [pH, pHH, pA, pL]
	
