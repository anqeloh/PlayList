extends Control

signal textbox_closed

@onready var experience_bar = $ExperienceBar
var enemies = [
	preload("res://Resource/godot_png.tres"), 
	preload("res://Resource/godot_png2.tres")
	]

var playerData = FileSave.playerData
var save_file_path = "user://save/"
var save_file_name = "Player.tres"

var random_index = randi_range(0, enemies.size()- 1)
var enemy = enemies[random_index]
var current_player_health = 0
var current_enemy_health = 0
var rng: RandomNumberGenerator
var is_defending = false
var ex_gained = 40



func _ready():
	if ( ResourceLoader.exists( save_file_path + save_file_name ) ):
		lload()
	set_health($PlayerPanel/PlayerData/ProgressBar, playerData.health, playerData.max_health) #Player Global Health
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health) #Enemy Health from Resource
	$EnemyContainer2/Enemy.texture = enemy.texture #Texture Image should be from the Resource
	current_player_health = playerData.health
	current_enemy_health = enemy.health
	experience_bar.initialize(playerData.experience, playerData.experience_rq)
	
	$AnimationPlayer.play("enemy_start")
	display_text("%s has appeared!" % enemy.name)
	await self.textbox_closed
	display_text("What will you do?")
	$ActionsPanel/Actions1.show()
	$ActionsPanel/Actions2.show()
	rng = RandomNumberGenerator.new()

func _process(delta):
	pointer_on_focus()


func set_health(progress_bar, health, max_health):
	var tween = get_tree().create_tween()
	tween.tween_property(progress_bar, "value", health, 0.4)
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]
func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible:
		textbox_closed.emit()

func display_text(text):
	$TextBox/Label.text = text

func enemy_turn():
	display_text("%s attacks you back!" % enemy.name)
	await self.textbox_closed
	if is_defending:
		is_defending = false
		$AnimationPlayer.play("defend")
		await $AnimationPlayer.animation_finished
		display_text("No damage was taken")
		await self.textbox_closed
		await (get_tree().create_timer(0.5).timeout)
		$ActionsPanel/Actions1.show()
		$ActionsPanel/Actions2.show()
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		playerData.change_health(-(enemy.damage))
		print(playerData.health)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, playerData.max_health)
		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished
		display_text("%s dealt %d damage to you!" % [enemy.name, enemy.damage])
		await self.textbox_closed
		await (get_tree().create_timer(0.5).timeout)
	if current_player_health <= 0:
		display_text("you died")
		await self.textbox_closed
		get_tree().quit()
	else:
		$AttackPanel.hide()
		$AttackPanel/Actions.show()
		$AttackPanel/Actions2.show()
		$ActionsPanel/Actions1.show()
		$ActionsPanel/Actions2.show()
		$ActionsPanel.show()
		display_text("What will you do?")
	
	
func _on_run_pressed():
	$ActionsPanel/Actions1.hide()
	$ActionsPanel/Actions2.hide()
	display_text("You have escaped.")
	await self.textbox_closed
	await (get_tree().create_timer(0.25).timeout)
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_attack_pressed():
	$ActionsPanel.hide()
	$AttackPanel.show()


func _on_defend_pressed():
	rng.randomize()
	var randomValue = rng.randi_range(1, 2)
	if not randomValue == 2:
		is_defending = true
		$ActionsPanel/Actions1.hide()
		$ActionsPanel/Actions2.hide()
		display_text("You defended. . .")
		await self.textbox_closed
		enemy_turn()
	else:
		$ActionsPanel/Actions1.hide()
		$ActionsPanel/Actions2.hide()
		display_text("you failed to defend!")
		await self.textbox_closed
		enemy_turn()
	


func _on_attack_1_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You attacked. . .")
	await self.textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - playerData.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You dealt %d damage!" % playerData.damage)
	await self.textbox_closed
	enemy_health_checker()


func _on_attack_2_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You attacked. . .")
	await self.textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - playerData.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You dealt %d damage!" % playerData.damage)
	await self.textbox_closed
	enemy_health_checker()


func _on_attack_3_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You attacked. . .")
	await self.textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - playerData.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You dealt %d damage!" % playerData.damage)
	await self.textbox_closed
	enemy_health_checker()


func _on_attack_4_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You attacked. . .")
	await self.textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - playerData.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You dealt %d damage!" % playerData.damage)
	await self.textbox_closed
	enemy_health_checker()
	
func enemy_health_checker():
	if current_enemy_health == 0:
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		display_text("%s was defeated." % enemy.name)
		await self.textbox_closed
		playerData.gain_experience(ex_gained)
		await (get_tree().create_timer(1.75).timeout)
		display_text("You recieved %s experience." % ex_gained)
		await self.textbox_closed
		ssave()
		WorldSignals.use_load = true
		await (get_tree().create_timer(0.25).timeout)
		get_tree().change_scene_to_file("res://Scenes/world.tscn")
	else:
		enemy_turn()
func pointer_on_focus():
	if $AttackPanel/Actions/Attack1.is_hovered():
		display_text("Attack 1: Attacks the enemy.")
	if $AttackPanel/Actions/Attack2.is_hovered():
		display_text("Attack 2: Attacks the enemy!")
	if $AttackPanel/Actions2/Attack3.is_hovered():
		display_text("Attack 3: Attacks the enemy?")
	if $AttackPanel/Actions2/Attack4.is_hovered():
		display_text("Attack 4: Attacks the enemy...")
	
func lload():
	playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
func ssave():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("save")
	print(playerData.global_position)
	print(playerData.health)
