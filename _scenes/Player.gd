extends KinematicBody2D
class_name Player

signal player_hit
signal player_collide

export var speed = 300.0
var ready_to_shoot = false
var shot = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	if Input.is_action_pressed("right"):
		velocity.x = speed
	if Input.is_action_pressed("up"):
		velocity.y = -speed
	if Input.is_action_pressed("down"):
		velocity.y = speed
	
	for slide in get_slide_count():
		var collision := get_slide_collision(slide)
		
		if collision.collider.is_in_group("invader"):
			print("PLAYER COLLIDED")
			player_hit()
			
	
	move_and_slide(velocity, Vector2.UP)

func get_shoot_status():
	return ready_to_shoot

func set_shoot_status(status):
	ready_to_shoot = status
	

func shoot(var projectile):
	var l = projectile.instance()
	l.position = $Gun.global_position
	return l

#=====SIGNALS=====#
func player_collision():
	emit_signal("player_collide")
	print("Player collided with Invader")

func player_hit():
	emit_signal("player_hit")
	queue_free()

func ready_to_shoot():
	ready_to_shoot = true
