extends Node


var invaders_prefab = preload("res://_scenes/Invaders.tscn")
var invaders

var player_prefab = preload("res://_scenes/Player.tscn")
var player

var bomb_prefab = preload("res://_scenes/Bomb.tscn")
var bomb

var laser_prefab = preload("res://_scenes/Laser.tscn")
var laser

var bonus_invader_prefab = preload("res://_scenes/BonusInvader.tscn")
var bonus_invader
var bonus_direction = 1
var bonus_pos

var projectiles

# status vars
var num_lives
var num_bombs

# difficulty scaling
var difficulty = 1

# score
var score = 0

func _ready():
	randomize()
	load_game()
	invaders.connect("invader_shoot", self, "_on_invader_shoot_timeout")
#	invaders = $Invaders
#	player = $Player
	pass 

func _process(delta):
	if Input.is_action_pressed("reset"):
		reset_game()
	
	if Input.is_action_pressed("start"):
		start_game()
	
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

func start_game():
	$BonusTimer.start()
	invaders.start_timers()
	player.ready_to_shoot()

func stop_game():
	$BonusTimer.stop()
	invaders.stop_timers()
	player = null
	pass

func load_game():
	num_lives = 3
	score = 0
	difficulty = 1
	
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

func spawn_bonus_ship():
	bonus_invader = bonus_invader_prefab.instance()
	bonus_invader.init(bonus_direction)
	add_child(bonus_invader)
	bonus_invader.global_position = bonus_pos
	pass

func update_score():
	$UI/Points/ScoreContainer/VBoxContainer/Score.text = str(score)

#=====SIGNALS=====#

# update life counter when player is hit
func _on_Player_player_hit():
	$RespawnTimer.start()
	stop_game()
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
	update_score()
	pass

func _on_invader_hit(row: int):
	score += (row * 10)
	update_score()
	pass # Replace with function body.

func _on_last_invader_hit():
	$LevelTimer.start()
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
