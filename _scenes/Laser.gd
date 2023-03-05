extends KinematicBody2D
class_name Laser


export var speed = 600
signal bomb_hit

var velocity = Vector2.ZERO


func _ready():
	pass
	
func _physics_process(delta):
	velocity.y = -speed
	move_and_slide(velocity, Vector2.UP)
	
	for slide in get_slide_count():
		var collision := get_slide_collision(slide)
		
		if collision.collider is Invader:
			collision.collider.invader_hit()
			laser_hit()

		elif !(collision.collider is Invader):
			collision.collider.bomb_hit()
			laser_hit()

func laser_hit():
	emit_signal("laser_hit")
	queue_free()

