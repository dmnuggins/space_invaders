extends Node

var invaders_prefab = preload("res://_scenes/Invaders.tscn")
var invaders
var player_prefab = preload("res://_scenes/Player.tscn")
var player

var num_lives
var num_bombs

func _ready():
	pass 


func _on_Top_body_entered(body):
	print("TOP entered")
	body.queue_free()
	pass # Replace with function body.


func _on_Bottom_body_entered(body):
	print("BOTTOM entered")
	body.queue_free()
	pass # Replace with function body.
