extends KinematicBody2D
class_name Invader

export var row = 0

var speed = 300.0

signal clear
signal not_clear
signal invader_hit

func _ready():
	pass

func _physics_process(delta):
	pass

# checks if invader is not blocked by another invader node
func ready_to_shoot() -> bool:
	var area = $InvaderSight
	for body in area.get_overlapping_bodies():
		if body.is_in_group("invader"):
			return false
	return true

#=====SIGNALS=====#

func invader_hit():
	emit_signal("invader_hit", row)
	queue_free()

