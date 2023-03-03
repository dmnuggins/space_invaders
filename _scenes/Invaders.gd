extends Node2D

export var row = 0
var move_direction = 1
var move_down_count = 0
var bound_entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# on each timer reset, position of the Invader nodes are moved
func _on_MoveTimer_timeout():
	if !bound_entered:
		update_position()
	else:
		move_down()
		bound_entered = false
	pass # Replace with function body.

# positional limits 10px (left) 590px (right)
func update_position():
	position.x += 10 * move_direction
	pass

func move_down():
	position.y += 10

func _on_LeftBound_body_entered(body):
	move_direction = 1
	bound_entered = true
	pass # Replace with function body.


func _on_RightBound_body_entered(body):
	move_direction = -1
	bound_entered = true
	pass # Replace with function body.
