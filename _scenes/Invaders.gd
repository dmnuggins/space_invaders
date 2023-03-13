extends Node2D

export var row = 0

var invaders

var move_direction = 1
var move_down_count = 0
var bound_entered = false
var ready_to_fire = false
var game_running = true
var num_invaders_left = 0
var animation_played = false
var timer = 1
var speed = 1
var difficulty = 1

# used to determine the random invader to fire their weapon
var rand_row
var rand_invader
var rand_time_interval

# signals
signal last_invader_hit
signal invader_hit
signal invader_shoot

func _ready():
	randomize()
	_connect_signals()
	count_invaders()

func _process(delta):
	# check if no invaders left
	if no_invaders():
		$ShootTimer.stop()
		$MoveTimer.stop()
	pass

func count_invaders():
	invaders = get_tree().get_nodes_in_group("invader")
	for invader in invaders:
		num_invaders_left += 1

# connects invader signals
func _connect_signals():
	invaders = get_tree().get_nodes_in_group("invader")
	for invader in invaders:
		invader.connect("invader_hit", self, "_on_invader_hit")
		# connect signal of observer node (in this case, invader) to function handling that signal
	
	# invaders movement bound signal connectors
	var walls = get_tree().get_nodes_in_group("bounds")
	var left_wall = walls[0]
	var right_wall = walls[1]
	left_wall.connect("body_entered", self,"_on_LeftBound_body_entered")
	right_wall.connect("body_entered", self,"_on_RightBound_body_entered")
	# connect signals to outer wall bounds

# update position of invaders by set unit of 10px
func update_position():
	var rows = get_children()
	for row_num in rows:
		if !(row_num is Timer):
			row_num.position.x += (10 * move_direction)
	pass

# checks if number of invaders is more than 0
func no_invaders() -> bool:
	if get_visible_invaders().size() > 0:
		return false
	return true

# shoots projectile
func shoot(var projectile):
	# array of invaders not blocked
	var vis_invaders = get_visible_invaders()
	
	rand_invader = (randi() % vis_invaders.size())
#	rand_time_interval = (randi() % 2 + 1)
	
	# gets random invader from visible invader array
	var invader = vis_invaders[rand_invader]
	var b = projectile.instance()
	b.position = invader.get_node("Gun").global_position
	return b

# return an array of invaders that are not blocked by other invaders below them
func get_visible_invaders():
	var rows = get_children()
	var invader_row
	var invader
	var visible_array = []
	
	for i in rows:
		if !(i is Timer):
#			print(i)
			invader_row = i.get_children()
			for j in invader_row:
				j.check_sight()
				if(j.ready_to_shoot()):
					visible_array.push_back(j)
	return visible_array

func get_invaders():
	var rows = get_children()
	var invader_row
	var invader
	var invader_array = []
	
	for i in rows:
		if !(i is Timer):
			invader_row = i.get_children()
			for j in invader_row:
				invader_array.push_back(j)
	return invader_array
	

func start_timers():
	$MoveTimer.start()
	$ShootTimer.start()
func stop_timers():
	$MoveTimer.stop()
	$ShootTimer.stop()

#=====SIGNALS=====#

# on each timer reset, position of the Invader nodes are moved
func _on_MoveTimer_timeout():
	var invaders = get_invaders()
	
	if !animation_played:
		for i in invaders:
			i.get_node("Sprite").hide()
			i.get_node("AnimatedSprite").show()
			i.animate()
			pass
		animation_played = true
	
#	print($MoveTimer.wait_time)
	# moves invaders down an interval after edge is met
	if bound_entered:
#		print("bound entered")
		position.y += 15
		bound_entered = false
		if timer >= 0.5:
			timer -= 0.1
		elif timer <= 0.5:
			timer -= 0.01
		elif timer <= 0.2 && timer > 0.02:
			timer -= 0.001
		$MoveTimer.wait_time = timer
		
	elif !bound_entered:
		update_position()

# flips move direction of the invaders when KB2D enters A2D
func _on_LeftBound_body_entered(body: KinematicBody2D)->void:
	if body.is_in_group("invader"):
		move_direction = 1
		bound_entered = true

# flips move direction of the invaders when KB2D enters A2D
func _on_RightBound_body_entered(body: KinematicBody2D)->void:
	if body.is_in_group("invader"):
		move_direction = -1
		bound_entered = true

# when timeout, random invader will fire laser
func _on_ShootTimer_timeout():
	if !no_invaders():
#		shoot(projectile)
		emit_signal("invader_shoot")
	pass

func _on_invader_hit(row: int):
	print(num_invaders_left)
	num_invaders_left -= 1
	if num_invaders_left == 0:
		emit_signal("last_invader_hit")
		print("LAST INVADER HIT")
	emit_signal("invader_hit", row)
#	print("Row:", row)
