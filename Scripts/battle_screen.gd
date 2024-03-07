extends Control

signal textbox_closed

@export var enemy: Resource = null
var current_player_health = 0
var current_enemy_health = 0
var is_defending = false

func _ready():
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health) #Player Global Health
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health) #Enemy Health from Resource
	$EnemyContainer2/Enemy.texture = enemy.texture #Texture Image should be from the Resource
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$AnimationPlayer.play("enemy_start")
	display_text("A Wild %s Appears!" % enemy.name)
	await self.textbox_closed
	display_text("What will you do?")
	$ActionsPanel/Actions1.show()
	$ActionsPanel/Actions2.show()


func set_health(progress_bar, health, max_health):
	progress_bar.value = health
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
		$ActionsPanel/Actions1.show()
		$ActionsPanel/Actions2.show()
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished
		display_text("%s delt %d damage at you!" % [enemy.name, enemy.damage])
		await self.textbox_closed
	$AttackPanel.hide()
	$AttackPanel/Actions.show()
	$AttackPanel/Actions2.show()
	$ActionsPanel.show()
	display_text("What will you do?")
	
func _on_run_pressed():
	$ActionsPanel/Actions1.hide()
	$ActionsPanel/Actions2.hide()
	display_text("You have escaped.")
	await self.textbox_closed
	await (get_tree().create_timer(0.25).timeout)
	get_tree().quit()


func _on_attack_pressed():
	$ActionsPanel.hide()
	$AttackPanel.show()


func _on_defend_pressed():
	is_defending = true
	$ActionsPanel/Actions1.hide()
	$ActionsPanel/Actions2.hide()
	display_text("You defended. . .")
	await self.textbox_closed
	await (get_tree().create_timer(0.25).timeout)
	enemy_turn()


func _on_attack_1_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You attacked. . .")
	await self.textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You delt %d damage!" % State.damage)
	await self.textbox_closed
	
	if current_enemy_health == 0:
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		display_text("%s was defeated." % enemy.name)
		await self.textbox_closed
		await (get_tree().create_timer(0.25).timeout)
		get_tree().quit()
	else:
		enemy_turn()


func _on_attack_2_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You attacked. . .")
	await self.textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You delt %d damage!" % State.damage)
	await self.textbox_closed
	
	if current_enemy_health == 0:
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		display_text("%s was defeated." % enemy.name)
		await self.textbox_closed
		await (get_tree().create_timer(0.25).timeout)
		get_tree().quit()
	else:
		enemy_turn()


func _on_attack_3_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You attacked. . .")
	await self.textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You delt %d damage!" % State.damage)
	await self.textbox_closed
	
	if current_enemy_health == 0:
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		display_text("%s was defeated." % enemy.name)
		await self.textbox_closed
		await (get_tree().create_timer(0.25).timeout)
		get_tree().quit()
	else:
		enemy_turn()


func _on_attack_4_pressed():
	$AttackPanel/Actions.hide()
	$AttackPanel/Actions2.hide()
	display_text("You attacked. . .")
	await self.textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You delt %d damage!" % State.damage)
	await self.textbox_closed
	
	if current_enemy_health == 0:
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		display_text("%s was defeated." % enemy.name)
		await self.textbox_closed
		await (get_tree().create_timer(0.25).timeout)
		get_tree().quit()
	else:
		enemy_turn()
	
