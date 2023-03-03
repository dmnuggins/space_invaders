extends KinematicBody2D
class_name Invader

export (PackedScene) var laser

var speed = 300.0

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	pass

#func  shoot():
#	var l = laser.instance()
#	owner.add_child(l)
#	l.position = $Gun.global_position
