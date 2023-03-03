extends KinematicBody2D
class_name Laser


export var speed = 600
signal laser_hit

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func _physics_process(delta):
	velocity.y = -speed
	move_and_slide(velocity, Vector2.UP)
	
	for slide in get_slide_count():
		var collision := get_slide_collision(slide)
		
		if collision.collider is Invader:
			print("Invader HIT")
			laser_hit()
		if collision.collider is Player:
			print("Player HIT")
			laser_hit()

func laser_hit():
	emit_signal("laser_hit")
	queue_free()

