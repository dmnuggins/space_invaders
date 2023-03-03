extends Node2D

export var row = 0
var move_direction = 1
var move_down_count = 0
var bound_entered = false

func _ready():
	pass

func _process(delta):
	pass

# on each timer reset, position of the Invader nodes are moved
func _on_MoveTimer_timeout():
	if !bound_entered:
		update_position()
	elif bound_entered:
		position.y += 10
		bound_entered = false
	pass

# positional limits 10px (left) 590px (right)
func update_position():
	position.x += 10 * move_direction
	pass

func _on_LeftBound_body_entered(body: KinematicBody2D)->void:
	if body.is_in_group("enemy"):
		move_direction = 1
		bound_entered = true
		print("LEFT bound entered")
	else:
		print("Player has entered")


func _on_RightBound_body_entered(body: KinematicBody2D)->void:
	if body.is_in_group("enemy"):
		move_direction = -1
		bound_entered = true
		print("RIGHT bound entered")
	else:
		print("Player has entered")
