extends KinematicBody2D
class_name Invader

export (PackedScene) var bomb

var speed = 300.0

signal clear
signal not_clear
signal hit

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	pass

func ready_to_shoot() -> bool:
	var area = $InvaderSight
	for body in area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			return false
	return true

func invader_hit():
	emit_signal("hit")

#func shoot():
#	var b = bomb.instance()
#	owner.add_child(b)
#	b.position = $Gun.global_position
##	print("GUN x:", $Gun.global_position.x, " y:", $Gun.position.y)
