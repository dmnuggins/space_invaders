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
	
	if invader_hit():
#		print("Invader destroyed")
		pass
	
#	for slide in get_slide_count():
#		var collision := get_slide_collision(slide)
#
#		if collision.collider is Invader:
#			print("Invader HIT")
#			laser_hit()
#		if collision.collider is Player:
#			print("Player HIT")
#			laser_hit()

func laser_hit():
	emit_signal("laser_hit")
	queue_free()

func invader_hit() -> bool:
	
	for slide in get_slide_count():
		var collision := get_slide_collision(slide)
		
		if collision.collider is Invader:
			collision.collider.invader_hit()
			laser_hit()
			return true
		if !(collision.collider is Player):
			collision.collider.bomb_hit()
			laser_hit()
			return true
	return false

