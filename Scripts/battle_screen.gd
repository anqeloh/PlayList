extends Control

signal textbox_closed

@onready var experience_bar = $ExperienceBar
@onready var enemy_sprite = $EnemyContainer2/Enemy
@onready var world = $"../.."
@onready var qt_eevent = $QTEevent

var _FileData = FileSave.lload()
var enemies = [
	preload("res://Resource/godot_png2.tres")
	]


var save_file_path = "user://save/"
var save_file_name = "Player.tres"

var random_index = randi_range(0, enemies.size()- 1)
var enemy = enemies[random_index]
var current_player_health = 0
var current_enemy_health = 0
var rng: RandomNumberGenerator
var is_defending = false
var magic_checker = false
var ex_gained = 240

var pHealth
var pDefense
var pMax_health
var pDamage
var pStrength
var pMagic
var pExperience
var pExperience_rq

var starting_player_str
var starting_player_mag


func start():
	await up_stats()
	#qt_eevent.paused = true
	set_health($PlayerPanel/PlayerData/ProgressBar, pHealth, pMax_health) #Player Global Health
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health) #Enemy Health from Resource
	enemy_sprite.sprite_frames = enemy.texture #Texture Image should be from the Resource
	current_player_health = pHealth
	current_enemy_health = enemy.health
	experience_bar.initialize(pExperience, pExperience_rq)
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("enemy_start")
	display_text("%s has appeared!" % enemy.name)
	await self.textbox_closed
	display_text("What will you do?")
	$ActionsPanel/Actions1.show()
	$ActionsPanel/Actions2.show()
	WorldSignals.QTE.connect(OPdamage)
	rng = RandomNumberGenerator.new()
func up_stats():
	pHealth = _FileData.playerData.health
	pDefense = _FileData.playerData.defense
	pMax_health = _FileData.playerData.max_health
	pDamage = _FileData.playerData.damage
	pStrength = _FileData.playerData.strength
	pMagic = _FileData.playerData.magic
	pExperience = _FileData.playerData.experience
	pExperience_rq = _FileData.playerData.experience_rq
	starting_player_str = pStrength
	starting_player_mag = pMagic

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
	# BELOW THIS VVV IS JUST TESTING THE GAME MORE FASTER
	if Input.is_action_just_pressed("test_button"):
		start()

func display_text(text):
	$TextBox/Label.text = text

func enemy_turn():
	display_text("%s attacks you back!" % enemy.name)
	await self.textbox_closed
	if is_defending:
		$AnimationPlayer.play("defend")
		await $AnimationPlayer.animation_finished
		current_enemy_health = max(0, current_enemy_health - (pDamage * 2))
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		display_text("No damage was taken, Enemy has taken recoil!")
		await self.textbox_closed
		await enemy_health_checker()
		
	else:
		current_player_health = max(0, current_player_health - round(enemy.damage * (1-(pDefense * 0.02))))
		enemy_sprite.play()
		await (get_tree().create_timer(0.8).timeout)
		enemy_sprite.stop()
		_FileData.playerData.change_health(-(enemy.damage))
		pHealth = _FileData.playerData.health
		print(pHealth)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, pMax_health)
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
	pStrength = starting_player_str
	pMagic = starting_player_mag
	await (get_tree().create_timer(0.25).timeout)
	WorldSignals.use_load = true
	LevelTransition.show()
	await LevelTransition.fade_in()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_attack_pressed():
	$ActionsPanel.hide()
	$AttackPanel.show()


func _on_defend_pressed():
	var randomValue = rng.randi_range(0, 5)
	rng.randomize()
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
	
func _on_heal_pressed():
	$ActionsPanel/Actions1.hide()
	$ActionsPanel/Actions2.hide()
	var randomValue = rng.randi_range(1, 10)
	rng.randomize()
	if not randomValue == 8:
		current_player_health = max(0, current_player_health + round(enemy.damage * (1 + (pMagic * 0.05))))
		if current_player_health >= pMax_health:
			current_player_health = pMax_health
			pHealth = pMax_health
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, pMax_health)
		else:
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, pMax_health)
			_FileData.playerData.change_health((enemy.damage * 2))
			pHealth = _FileData.playerData.health
		print(pHealth)
		display_text("You Have Healed")
		await self.textbox_closed
		enemy_turn()
	else:
		current_player_health = max(0, current_player_health - (enemy.damage * 2))
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, pMax_health)
		_FileData.playerData.change_health(-(enemy.damage * 2))
		print(pHealth)
		display_text("You Failed to Heal")
		await self.textbox_closed
		enemy_turn()

func _on_attack_1_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You attacked. . .")
	await self.textbox_closed
	var randomValue = rng.randi_range(1,5)
	rng.randomize()
	if not randomValue == 1:
		current_enemy_health = max(0, current_enemy_health - round(pDamage * (1 + (pStrength * 0.05))))
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		$AnimationPlayer.play("enemy_damaged")
		await $AnimationPlayer.animation_finished
		
		display_text("You dealt %d damage!" % round(pDamage * (1 + (pStrength * 0.05))))
		await self.textbox_closed
		enemy_health_checker()
	else:
		current_enemy_health = max(0, current_enemy_health - (2 * (round(pDamage * (1+(pStrength * 0.05))))))
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		$AnimationPlayer.play("enemy_damaged")
		await $AnimationPlayer.animation_finished
		display_text("Critical hit! You dealt %d damage!" % (2 * round(pDamage * ((pStrength * 0.05) + 1))))
		await self.textbox_closed
		enemy_health_checker()


func _on_attack_2_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You attacked. . .")
	await self.textbox_closed
	var randomValue = rng.randi_range(1,5)
	rng.randomize()
	if not randomValue == 1 or not randomValue == 2:
		current_enemy_health = max(0, current_enemy_health - round(pDamage * ((pMagic * 0.03) +1 )))
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		$AnimationPlayer.play("enemy_damaged")
		await $AnimationPlayer.animation_finished
		display_text("You dealt %d damage!" % round(pDamage * ((pMagic * 0.03) + 1)))
		await self.textbox_closed
		enemy_health_checker()
	else:
		current_enemy_health = max(0, current_enemy_health - round(pDamage * ((pMagic * 0.03) + 1)))
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		$AnimationPlayer.play("enemy_damaged")
		await $AnimationPlayer.animation_finished
		#if current_enemy_health == 0:
			#display_text("You dealt %d damage!" % round(pDamage * ((pMagic * 0.03) + 1)))
		#else:
			#display_text("You dealt %d damage and can follow up!" % round(pDamage * ((pMagic * 0.03)+1)))
			#await self.textbox_closed
		magic_checker = true
		enemy_health_checker()
		

func _on_attack_3_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("Quicktime Event")
	await self.textbox_closed
	$TextBox.hide()
	#qt_eevent.paused = false
	qt_eevent.show()
	
	
	


func _on_attack_4_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You powered up. . .")
	await self.textbox_closed
	player_strength_increase()
	
	display_text("Your strength increased to %d!" % pStrength)
	await self.textbox_closed
	enemy_health_checker()
	
func enemy_health_checker():
	if current_enemy_health == 0:
		pStrength = starting_player_str
		pMagic = starting_player_mag
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		display_text("%s was defeated." % enemy.name)
		await self.textbox_closed
		_FileData.playerData.gain_experience(ex_gained)
		await (get_tree().create_timer(1.75).timeout)
		display_text("You recieved %s experience." % ex_gained)
		await self.textbox_closed
		round_end()
	else:
		if is_defending:
			is_defending = false
			await (get_tree().create_timer(0.5).timeout)
			$ActionsPanel/Actions1.show()
			$ActionsPanel/Actions2.show()
			
		elif magic_checker:
			magic_enemy_health_checker()
			magic_checker = false
		else:
			enemy_turn()
			
func OPdamage():
	if WorldSignals.qte_pressed:
		current_enemy_health = max(0, current_enemy_health - round(pDamage * (1 + (pStrength * 3))))
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		$AnimationPlayer.play("enemy_damaged")
		await $AnimationPlayer.animation_finished
		qt_eevent.hide()
		#qt_eevent.paused = true
		$TextBox.show()
		display_text("Super Attacked.")
		await self.textbox_closed
		enemy_health_checker()
		WorldSignals.qte_pressed = false
	else:
		current_player_health = max(0, current_player_health - round(pDamage * (1 + (pStrength * 3))))
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, pMax_health)
		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished
		qt_eevent.hide()
		$TextBox.show()
		display_text("You have failed and lost completely.")
		await self.textbox_closed
		round_end_lost()
func pointer_on_focus():
	if $AttackPanel/Actions/Attack1.is_hovered():
		display_text("Attack 1: Attacks the enemy.")
	if $AttackPanel/Actions/Attack2.is_hovered():
		display_text("Attack 2: Attacks the enemy!")
	if $AttackPanel/Actions2/Attack3.is_hovered():
		display_text("Attack 3: Attacks the enemy?")
	if $AttackPanel/Actions2/Attack4.is_hovered():
		display_text("Attack 4: Attacks the enemy...")
		
func magic_enemy_health_checker():
	if current_enemy_health == 0:
		pStrength = starting_player_str
		pMagic = starting_player_mag
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		display_text("%s was defeated." % enemy.name)
		await self.textbox_closed
		_FileData.playerData.gain_experience(ex_gained)
		await (get_tree().create_timer(1.75).timeout)
		display_text("You recieved %s experience." % ex_gained)
		await self.textbox_closed
		round_end()
	else:
		$AttackPanel.hide()
		$AttackPanel/Actions.show()
		$AttackPanel/Actions2.show()
		$ActionsPanel/Actions1.show()
		$ActionsPanel/Actions2.show()
		$ActionsPanel.show()
		display_text("What will you do?")
		
func player_strength_increase():
	pStrength *= 2

func player_magic_increase():
	pMagic *= 2

func round_end():
	await (get_tree().create_timer(0.25).timeout)
	LevelTransition.show()
	await LevelTransition.fade_in()
	self.hide()
	_FileData.ssave()
	await LevelTransition.fade_out()
	LevelTransition.hide()
	WorldSignals.battle_end.emit()
	
func round_end_lost():
	await (get_tree().create_timer(0.25).timeout)
	LevelTransition.show()
	await LevelTransition.fade_in()
	self.hide()
	get_tree().reload_current_scene()
	await LevelTransition.fade_out()
	LevelTransition.hide()
	WorldSignals.battle_end.emit()
