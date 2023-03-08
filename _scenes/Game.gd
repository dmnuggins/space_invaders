extends Node

var invaders_prefab = preload("res://_scenes/Invaders.tscn")
var invaders
var invaders_signal
var player_prefab = preload("res://_scenes/Player.tscn")
var player
var laser_prefab = preload("res://_scenes/Laser.tscn")
var bomb_prefab = preload("res://_scenes/Bomb.tscn")
var bomb
var bonus_invader_prefab = preload("res://_scenes/BonusInvader.tscn")
var bonus_invader
var bonus_direction = 1
var bonus_pos
var projectiles


var num_lives
var num_bombs

#score
var score = 0

func _ready():
	randomize()
	load_game()
	invaders.connect("invader_shoot", self, "_on_invader_shoot_timeout")
	invaders = $Invaders
	player = $Player
	pass 

func _process(delta):
	if Input.is_action_pressed("up"):
		reset_game()
	pass

func _connect_signals():
#	bonus_invader = get_parent().get_node("BonusInvader")
#	bonus_invader.connect("bonus_hit", self, "_on_bonus_invader_hit")
	# need to connnect bonus invader signal when spawned
	
	pass

func load_game():
	num_lives = 3
	score = 0
	invaders = invaders_prefab.instance()
	add_child(invaders)
	invaders.connect("invader_hit", self, "_on_invader_hit")
	invaders.connect("last_invader_hit", self, "_on_last_invader_hit")


func reset_game():
	# despawn all invaders
	invaders.queue_free()
	
	
	# despawn player
#	player.queue_free()
	
	# despawn all projectiles
	projectiles = get_tree().get_nodes_in_group("projectiles")
	for projectile in projectiles:
		projectile.queue_free()# despawn all projectiles
	
	# instantiate invaders
	invaders = invaders_prefab.instance()
	add_child(invaders)
#	player = player_prefab.instance()
#	add_child(player)
#	player.global_position.x = 320
#	player.global_position.y = 750
	
	# connect signals
	invaders.connect("invader_hit", self, "_on_invader_hit")
	invaders.connect("last_invader_hit", self, "_on_last_invader_hit")
	invaders.connect("invader_shoot", self, "_on_invader_shoot_timeout")

func spawn_bonus_ship():
	bonus_invader = bonus_invader_prefab.instance()
	bonus_invader.init(bonus_direction)
	add_child(bonus_invader)
	bonus_invader.global_position = bonus_pos
	pass

func update_score():
	$UI/Score/ScoreLabel.text = str(score)

#=====SIGNALS=====#

func _on_Top_body_entered(body):
	print("TOP entered")
	body.queue_free()
	pass # Replace with function body.


func _on_Bottom_body_entered(body):
	print("BOTTOM entered")
	body.queue_free()
	pass # Replace with function body.

# update life counter when player is hit
func _on_Player_player_hit():
	pass # Replace with function body.

# on timeout, spawn bonus_invader
func _on_BonusTimer_timeout():
	match bonus_direction:
		1:
			bonus_pos = $BonusSpawns/LeftSpawn.position
		-1:
			bonus_pos = $BonusSpawns/RightSpawn.position
	spawn_bonus_ship()
	# CONNECT bonus connector HERE
	bonus_direction = -bonus_direction
	$BonusTimer.wait_time = (randi() % 11 + 30)
	print($BonusTimer.wait_time)
	pass # Replace with function body.

func _on_bonus_invader_hit(score: int):
	
	pass

func _on_invader_hit(row: int):
	score += (row * 10)
	update_score()
	pass # Replace with function body.

func _on_last_invader_hit():
#	reset_game()
	print("last invader hit")
	pass

func _on_invader_shoot_timeout():
	bomb = invaders.shoot(bomb_prefab)
	add_child(bomb)
	pass # Replace with function body.
