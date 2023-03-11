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
	load_highscore()
	load_game()
	invaders.connect("invader_shoot", self, "_on_invader_shoot_timeout")
#	invaders = $Invaders
#	player = $Player
	pass 

func _process(delta):
	# actions
	if Input.is_action_just_pressed("shoot"):
		if player != null:
			if player.get_shoot_status():
				laser = player.shoot(laser_prefab)
				add_child(laser)
				player.set_shoot_status(false)
				laser = get_tree().get_nodes_in_group("laser")[0]
				laser.connect("laser_hit", player, "ready_to_shoot")
	pass

#=====GAME FLOW=====#

func load_highscore():
	var file = File.new()
	if not file.file_exists(filepath): return
	file.open(filepath, File.READ)
	highscore = file.get_var()
	file.close()

func save_highscore():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(highscore)
	file.close()

func set_highscore(value):
	highscore = value
	save_highscore()

func start_game():
	$BonusTimer.start()
	invaders.start_timers()
	player.ready_to_shoot()
	$BackgroundMusic.play()

func stop_game():
	$BonusTimer.stop()
	invaders.stop_timers()
	player = null
	$BackgroundMusic.stop()
	pass

func load_game():
	num_lives = 3
	score = 0
	difficulty = 1
	
	ui.update_score(score)
	ui.update_lives(num_lives)
	
	# instantiate invaders
	invaders = invaders_prefab.instance()
	invaders.global_position.y += 50
	add_child(invaders)
	
	# instantiate player
	player = player_prefab.instance()
	player.global_position = Vector2(320, 750)
	add_child(player)
	
	player.connect("player_hit", self, "_on_Player_player_hit")
	invaders.connect("invader_hit", self, "_on_invader_hit")
	invaders.connect("last_invader_hit", self, "_on_last_invader_hit")
	invaders.connect("invader_shoot", self, "_on_invader_shoot_timeout")

func reset_game():
	# despawn all invaders
	invaders.queue_free()
	if player != null:
		player.queue_free()
	# despawn all projectiles
	projectiles = get_tree().get_nodes_in_group("projectiles")
	for projectile in projectiles:
		projectile.queue_free()

	# reset values
	difficulty = 1
	score = 0
	num_lives = 3
	
	load_game()

func game_over():
	ui.show_menu()
	pass

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
	print("player_hit")
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
			bonus_pos = $BonusSpawns/LeftSpawn.position
		-1:
			bonus_pos = $BonusSpawns/RightSpawn.position
	spawn_bonus_ship()
	# connect bonus ship signal
	var bonus_ship = get_tree().get_nodes_in_group("bonus")[0]
	bonus_ship.connect("bonus_hit", self, "_on_bonus_invader_hit")
	bonus_direction = -bonus_direction
	
	$BonusTimer.wait_time = (randi() % 11 + 30)
	print($BonusTimer.wait_time)
	pass # Replace with function body.

func _on_bonus_invader_hit(value: int):
	score += value
	$Hit.play()
	ui.update_score(score)
	pass

func _on_invader_hit(row: int):
	score += (row * 10)
	print(score)
	$Hit.play()
	ui.update_score(score)
	pass # Replace with function body.

func _on_last_invader_hit():
	$LevelTimer.start()
	$BonusTimer.stop()
	print("LEVEL COMPLETE")
	pass

func _on_invader_shoot_timeout():
	bomb = invaders.shoot(bomb_prefab)
	add_child(bomb)
	pass # Replace with function body.

func _on_RespawnTimer_timeout():
	player = player_prefab.instance()
	player.global_position = Vector2(320, 750)
	add_child(player)
	player.connect("player_hit", self, "_on_Player_player_hit")
	start_game()
	$RespawnTimer.stop()
	pass # Replace with function body.


func _on_UI_start_game():
	start_game()
	pass # Replace with function body.


func _on_UI_play_again():
	reset_game()
	pass # Replace with function body.
