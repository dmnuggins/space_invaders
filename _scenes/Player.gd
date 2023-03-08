extends KinematicBody2D
class_name Player


export (PackedScene) var laser
signal player_hit

var speed = 300.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	if Input.is_action_pressed("right"):
		velocity.x = speed
	
	move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var l = laser.instance()
	owner.add_child(l)
	l.position = $Gun.global_position

#=====SIGNALS=====#

func player_hit():
	emit_signal("player_hit")
