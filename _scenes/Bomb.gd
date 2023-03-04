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
	
	if player_hit():
#		print("Player destroyed")
		pass

func bomb_hit():
	emit_signal("bomb_hit")
	queue_free()

func player_hit() -> bool:
	
	for slide in get_slide_count():
		var collision := get_slide_collision(slide)
		
		if collision.collider is Player :
			collision.collider.player_hit()
			bomb_hit()
			return true
		if !(collision.collider is Player):
			collision.collider.laser_hit()
			bomb_hit()
			return true
	return false

