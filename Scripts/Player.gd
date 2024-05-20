extends CharacterBody2D


const SPEED = 100
var current_dir = "none"
@onready var animated_sprite_2d = $AnimatedSprite2D

var npc_in_range = false
var sza_npc_in_range = false


func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	if not WorldSignals.in_dialogue:
		player_movement(delta)

func player_sell_method():
	pass

func player_shop_method():
	pass

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = SPEED
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -SPEED
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
			


func _on_area_2d_area_entered(area):
	if area.is_in_group("Portal"):
		await transition_in()
		position.x = 104
		position.y = -2990
		await transition_out()
	if area.is_in_group("Portal2"):
		await transition_in()
		position.x = -8
		position.y = -1557
		await transition_out()
		
func transition_in():
	LevelTransition.show()
	WorldSignals.in_dialogue = true
	await LevelTransition.fade_in()
	
func transition_out():
	await LevelTransition.fade_out()
	LevelTransition.hide()
	WorldSignals.in_dialogue = false
	
