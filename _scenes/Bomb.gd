extends KinematicBody2D
class_name Bomb


export var speed = 100
signal bomb_hit

var velocity = Vector2.ZERO


func _ready():
	pass
	
func _physics_process(delta):
	velocity.y = speed
	move_and_slide(velocity, Vector2.UP)
	
	for slide in get_slide_count():
		var collision := get_slide_collision(slide)
		
		if collision.collider.is_in_group("player"):
			collision.collider.player_hit()
			bomb_hit()
		elif collision.collider.is_in_group("laser"):
			collision.collider.laser_hit() 
			bomb_hit()
		elif collision.collider.is_in_group("projectile_bounds"):
			bomb_hit()
#=====SIGNALS=====#

func bomb_hit():
	emit_signal("bomb_hit")
	queue_free()
