extends KinematicBody2D
class_name Invader

export (PackedScene) var bomb

var speed = 300.0

signal clear
signal not_clear
signal hit

func _ready():
	pass

func _physics_process(delta):
	pass

# checks if invader is not blocked by another invader node
func ready_to_shoot() -> bool:
	var area = $InvaderSight
	for body in area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			return false
	return true

func invader_hit():
	emit_signal("hit")
	queue_free()

