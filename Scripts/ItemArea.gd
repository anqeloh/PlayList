extends Area2D

@export var item: InvItem
var player = null
var body_in = false
# Called when the node enters the scene tree for the first time.
func _ready():
	WorldSignals.item_collect.connect(item_collects)

func item_collects():
	if body_in:
		player.collect(item)


func _on_body_entered(body):
	body_in = true
	player = body


func _on_body_exited(body):
	body_in = false
