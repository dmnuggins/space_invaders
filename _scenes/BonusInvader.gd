extends KinematicBody2D
class_name Bonus

var speed = 200.0
var velocity = Vector2.ZERO
var score

signal bonus_hit

# set direction for spawn
func init(dir: int):
	velocity.x = speed * dir

func _physics_process(delta):
	move_and_slide(velocity, Vector2.UP)
	
	for slide in get_slide_count():
		var collision := get_slide_collision(slide)
		
		if collision.collider.is_in_group("wall"):
			bonus_hit()
		elif collision.collider.is_in_group("laser"):
			collision.collider.laser_hit()
			bonus_hit()

#=====SIGNALS=====#

func bonus_hit():
	emit_signal("bonus_hit", score)
	queue_free()
