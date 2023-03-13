extends Node

var invaders_prefab = preload("res://_scenes/Invaders.tscn")
var invaders

var player_prefab = preload("res://_scenes/Player.tscn")
var player

var bomb_prefab = preload("res://_scenes/Bomb.tscn")
var bomb

var laser_prefab = preload("res://_scenes/Laser.tscn")
var laser

onready var ui = $UI

var bonus_invader_prefab = preload("res://_scenes/BonusInvader.tscn")
var bonus_invader
var bonus_direction = 1
var bonus_pos

var projectiles

var game_paused = false

# status vars
var num_lives = 3
var num_bombs

# difficulty scaling
var difficulty = 1

# score
var score = 0
var highscore = 0
const filepath = "player://highscore.data"

func _ready():
	randomize()
	highscore = get_highscore()
	load_game()
	invaders.connect("invader_shoot", self, "_on_invader_shoot_timeout")
	invaders = $Invaders
	player = $Player
	pass 

func _process(delta):
	# actions
	if Input.is_action_just_pressed("shoot"):
		if !game_paused:
			if player.get_shoot_status():
				laser = player.shoot(laser_prefab)
				add_child(laser)
				player.set_shoot_status(false)
				laser = get_tree().get_nodes_in_group("laser")[0]
				laser.connect("laser_hit", player, "ready_to_shoot")
			
	pass

#=====GAME FLOW=====#
func get_highscore():
	Global.load()
	highscore = Global.save_data.high_score
	return highscore

func save_highscore(score: int):
	Global.save_data.high_score = score
	Global.save()

func start_game():
	game_paused = false
	$BonusTimer.start()
	invaders.start_timers()
	player.ready_to_shoot()
	$BackgroundMusic.play()

func stop_game():
	game_paused = true
	$BonusTimer.stop()
	invaders.stop_timers()
	$BackgroundMusic.stop()
	pass

func load_game():
	num_lives = 3
	score = 0
	difficulty = 1
	
	ui.update_score(score)
	ui.update_highscore(highscore)
	ui.update_lives(num_lives)
	
	# instantiate invaders
	invaders = invaders_prefab.instance()
	invaders.global_position.y += 50
	add_child(invaders)
	
	# instantiate player
	player = player_prefab.instance()
	player.global_position = Vector2(300, 720)
	add_child(player)
	
	player.connect("player_hit", self, "_on_Player_player_hit")
	invaders.connect("invader_hit", self, "_on_invader_hit")
	invaders.connect("last_invader_hit", self, "_on_last_invader_hit")
	invaders.connect("invader_shoot", self, "_on_invader_shoot_timeout")

func reset_game():
	clear_field()
	if invaders == null:
		pass
	else:
		invaders.queue_free()
	if num_lives >= 0:
		player.queue_free()
	
	# reset values
	difficulty = 1
	score = 0
	num_lives = 3
	
	load_game()

func game_over():
	if(score > highscore):
		Global.save_data.high_score = score
		Global.save()
	get_highscore()
	save_highscore(highscore)
	ui.show_menu()
	pass

func clear_field():
	# despawn projectiles
	projectiles = get_tree().get_nodes_in_group("projectiles")
	for projectile in projectiles:
		projectile.queue_free()

func spawn_bonus_ship():
	bonus_invader = bonus_invader_prefab.instance()
	bonus_invader.init(bonus_direction)
	add_child(bonus_invader)
	bonus_invader.global_position = bonus_pos
	pass

#=====SIGNALS=====#

# update life counter when player is hit
func _on_Player_player_hit():
	stop_game()
	$PlayerHit.play()
	num_lives -= 1
	ui.update_lives(num_lives)
	if num_lives < 0:
		game_over()
	else:
		$RespawnTimer.start()

	pass # Replace with function body.

# on timeout, spawn bonus_invader
func _on_BonusTimer_timeout():
	match bonus_direction:
		1:
			bonus_pos = $BonusSpawns/LeftSpawn.global_position
		-1:
			bonus_pos = $BonusSpawns/RightSpawn.global_position
	spawn_bonus_ship()
	# connect bonus ship signal
	var bonus_ship = get_tree().get_nodes_in_group("bonus")[0]
	bonus_ship.connect("bonus_hit", self, "_on_bonus_invader_hit")
	bonus_direction = -bonus_direction
	
	$BonusTimer.wait_time = (randi() % 11 + 30)
	pass # Replace with function body.

func _on_bonus_invader_hit(value: int):
	score += value
	$Hit.play()
	ui.update_score(score)
	pass

func _on_invader_hit(row: int):
	score += (row * 10)
	$Hit.play()
	ui.update_score(score)
	pass # Replace with function body.

func _on_last_invader_hit():
	clear_field()
	stop_game()
	game_over()
	pass

func _on_invader_shoot_timeout():
	bomb = invaders.shoot(bomb_prefab)
	add_child(bomb)
	pass # Replace with function body.

func _on_RespawnTimer_timeout():
	player = player_prefab.instance()
	player.global_position = Vector2(300, 720)
	add_child(player)
	player = get_tree().get_nodes_in_group("player")[0]
	player.connect("player_hit", self, "_on_Player_player_hit")
	start_game()
	$RespawnTimer.stop()
	pass # Replace with function body.

func _on_UI_start_game():
	start_game()
	pass # Replace with function body.

func _on_UI_play_again():
	reset_game()
	start_game()
	pass # Replace with function body.
