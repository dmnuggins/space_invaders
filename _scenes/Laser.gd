extends KinematicBody2D
class_name Laser

export var speed = 800
signal laser_hit

var velocity = Vector2.ZERO


func _ready():
	pass
	
func _physics_process(delta):
	velocity.y = -speed
	move_and_slide(velocity, Vector2.UP)
	
	for slide in get_slide_count():
		var collision := get_slide_collision(slide)
		
		if collision.collider.is_in_group("invader"):
			collision.collider.invader_hit()
			laser_hit()

		elif collision.collider.is_in_group("bomb"):
			collision.collider.bomb_hit()
			laser_hit()
		
		elif collision.collider.is_in_group("bonus"):
			collision.collider.bonus_hit()
			laser_hit()

		elif collision.collider.is_in_group("projectile_bounds"):
			laser_hit()

#=====SIGNALS=====#

func laser_hit():
	emit_signal("laser_hit")
	queue_free()
