extends Node2D


export var row = 0
export (PackedScene) var bomb

var move_direction = 1
var move_down_count = 0
var bound_entered = false
var ready_to_fire = false

# used to determine the random invader to fire their weapon
var rand_row
var rand_invader
var rand_time_interval


func _ready():
	randomize()
	# retrieve the row of invaders
#	var rows = get_children()
#	for row_num in rows:
#		# condition checks if child is not KB2D
#		if !(row_num is Timer):
#			print(row_num)
#		# get invaders
#		var invader_row = row_num.get_children()
#		for invaders in invader_row:
#			print(invaders)
	pass

func _process(delta):
	
	pass

# checks if invader line of sight is clear, otherwise return false
#func invader_clear() -> bool:
#
#	if invader.ready_to_shoot():
#		return true
#	return false

# positional limits 10px (left) 590px (right)
func update_position():
	var rows = get_children()
	for row_num in rows:
		if !(row_num is Timer):
			row_num.position.x += (10 * move_direction)

#	print("GUN x:", invader.get_node("Gun").global_position.x, " y:", invader.get_node("Gun").global_position.y)
#	print("Invader X:", invader.global_position.x, " Y:", invader.global_position.y)
	
	pass

func shoot():
	
	var vis_invaders = get_visible_invaders()

	rand_row = (randi() % 2)
	rand_invader = (randi() % 11)
	rand_time_interval = (randi() % 2 + 1)
	
#	var invader = get_invader(rand_row, rand_invader)
	var invader = vis_invaders[rand_invader]
	var b = bomb.instance()
	owner.add_child(b)
	b.position = invader.get_node("Gun").global_position

# gets random invader for firing
#func get_invader(rand_row: int, rand_invader: int):
#
#	var rows
#	var invaders
#	var invader
#
#	rows = get_children()
#	invaders = rows[rand_row].get_children()
#	invader = invaders[rand_invader]
#
#	return invader

# return an array of invaders that have visibility to shoot

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
#	print(visible_array)
	
	# returns ture for all children 
	
#	for row_num in rows:
#		# condition checks if child is not KB2D
#		if !(row_num is Timer):
#			invader_row = row_num.get_children()
#		for invaders in invader_row:
#			if invaders.ready_to_shoot():
#				visible_array.push_back(invaders)
#				print(invaders)
#	print(visible_array)

# SIGNALS

# on each timer reset, position of the Invader nodes are moved
func _on_MoveTimer_timeout():
	# moves invaders down an interval after edge is met
	if bound_entered:
		print("bound entered")
		position.y += 10
		bound_entered = false
		
	elif !bound_entered:
		update_position()
	pass
	
	
# flips move direction of the invaders when KB2D enters A2D
func _on_LeftBound_body_entered(body: KinematicBody2D)->void:
	if body.is_in_group("enemy"):
		move_direction = 1
		bound_entered = true

# flips move direction of the invaders when KB2D enters A2D
func _on_RightBound_body_entered(body: KinematicBody2D)->void:
	if body.is_in_group("enemy"):
		move_direction = -1
		bound_entered = true

# when timeout, random invader will fire laser
func _on_ShootTimer_timeout():
	shoot()
