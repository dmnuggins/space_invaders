extends KinematicBody2D
class_name Invader

export var row = 0

var speed = 300.0

signal invader_hit

func _ready():
	pass

func _physics_process(delta):
	
	pass

# checks if invader is not blocked by another invader node
func ready_to_shoot() -> bool:
	var collider = $RayCast2D.get_collider()
	if collider != null && collider.is_in_group("invader"):
		return false
	return true

func check_sight():
	$RayCast2D.force_raycast_update()

#=====SIGNALS=====#

func invader_hit():
	emit_signal("invader_hit", row)
	queue_free()

