extends KinematicBody2D
class_name Invader

export var row = 0

var speed = 300.0
var fps = 2

signal invader_hit


func _ready():
	match row:
		1:
			$Sprite.texture = load("res://_assets/invader_2_A.png")
		2:
			$Sprite.texture = load("res://_assets/invader_2_A.png")
		3:
			$Sprite.texture = load("res://_assets/invader_0.png")
		4:
			$Sprite.texture = load("res://_assets/invader_0.png")
		5:
			$Sprite.texture = load("res://_assets/invader_1_A.png")

func _physics_process(delta):
	pass

# checks if invader is not blocked by another invader node
func ready_to_shoot() -> bool:
	var collider = $RayCast2D.get_collider()
	if collider != null && collider.is_in_group("invader"):
		return false
	return true

func animate():
	match row:
		1:
			$AnimatedSprite.play("move_a")
		2:
			$AnimatedSprite.play("move_a")
		3:
			$AnimatedSprite.play("move_b")
		4:
			$AnimatedSprite.play("move_b")
		5:
			$AnimatedSprite.play("move_c")

func update_fps(value):
	$AnimatedSprite.speed_scale(value)

func check_sight():
	$RayCast2D.force_raycast_update()

#=====SIGNALS=====#

func invader_hit():
	emit_signal("invader_hit", row)
	queue_free()

