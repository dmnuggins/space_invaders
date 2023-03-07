extends Node

var invaders_prefab = preload("res://_scenes/Invaders.tscn")
onready var invaders = $Invaders
var player_prefab = preload("res://_scenes/Player.tscn")
var player
var bonus_invader_prefab = preload("res://_scenes/BonusInvader.tscn")
var bonus_invader
var bonus_direction = 1
var bonus_pos

var num_lives
var num_bombs

#score
var score = 0

func _ready():
	randomize()
	pass 

func _process(delta):
#	if Input.is_action_pressed("up"):
#		reset_game()
	pass

func _connect_signals():
	invaders = get_tree().get_nodes_in_group("invaders")
	invaders.connect("invader_hit", self, "_on_invader_hit")

#func load_game():
#	num_lives = 3
#	score = 0
#	invaders = invaders_prefab.instance()
#	add_child(invaders)
#	invaders.connect("invader_hit", self, "_on_invader_hit")
#	invaders.connect("last_invader_hit", self, "_on_last_invader_hit")
	

#func reset_game():
#	invaders.queue_free() # despawn all invaders
#
#	# instantiate invaders
#	invaders = invaders_prefab.instance()
#	add_child(invaders)
#	invaders.connect("invader_hit", self, "_on_invader_hit")
#	invaders.connect("last_invader_hit", self, "_on_last_invader_hit")

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
