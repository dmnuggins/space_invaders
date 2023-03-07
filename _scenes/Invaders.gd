extends Node2D

export var row = 0
export (PackedScene) var bomb

var invaders
#var bomb

var move_direction = 1
var move_down_count = 0
var bound_entered = false
var ready_to_fire = false
var game_running = true
var num_invaders_left = 44

# used to determine the random invader to fire their weapon
var rand_row
var rand_invader
var rand_time_interval

# signals
signal last_invader_hit
signal invader_hit

func _ready():
	randomize()
	_connect_signals()

func _process(delta):
	# check if no invaders left
	if no_invaders() && game_running:
		$ShootTimer.stop()
		$MoveTimer.stop()
		print("NO MORE INVADERS")
		game_running = false
	pass

# connects invader signals
func _connect_signals():
	invaders = get_tree().get_nodes_in_group("invader")
	for invader in invaders:
		invader.connect("invader_hit", self, "_on_invader_hit")
		# connect signal of observer node (in this case, invader) to function handling that signal
	
	# connect signals to outer wall bounds

# positional limits 10px (left) 590px (right)
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

func shoot():
	# array of invaders not blocked
	var vis_invaders = get_visible_invaders()
	
	rand_invader = (randi() % vis_invaders.size())
	rand_time_interval = (randi() % 2 + 1)
	
	# gets random invader from visible invader array
	var invader = vis_invaders[rand_invader]
	var b = bomb.instance()
	owner.add_child(b)
	b.position = invader.get_node("Gun").global_position

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
#				print(j)
#				print(j.ready_to_shoot())
				if(j.ready_to_shoot()):
					visible_array.push_back(j)
	
	return visible_array

#=====SIGNALS=====#

# on each timer reset, position of the Invader nodes are moved
func _on_MoveTimer_timeout():
	# moves invaders down an interval after edge is met
	if bound_entered:
		print("bound entered")
		position.y += 10
		bound_entered = false
		
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
		shoot()
		print("shoot")
	pass

func _on_invader_hit(row: int):
	num_invaders_left -= 1
	if num_invaders_left == 0:
		emit_signal("last_invader_hit")
		print("last_invader_hit")
	emit_signal("invader_hit", row)
	print("Row:", row)
