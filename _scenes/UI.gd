extends Control

onready var play_again_selector = $ReplayMenu/VBoxContainer/HBPlayContainer/Selector
onready var quit_selector = $ReplayMenu/VBoxContainer/HBoxQuitContainer/Selector
onready var score = $Points/ScoreContainer/VBoxContainer/Score
onready var high_score = $Points/HighScoreContainer/VBoxContainer/HighScore
onready var lives = $Status/LifePoints
onready var start = $MainMenu/VBoxContainer/HBoxContainer/Start

var blink = false

signal start_game
signal play_again

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func update_score(value: int):
	score.text = str(value)

func update_highscore(value: int):
	high_score.text = str(value)

func update_lives(num_lives: int):
	if(num_lives >= 0):
		lives.text = str(num_lives)

func show_menu():
	$ReplayMenu.show()

func hide_menu():
	$ReplayMenu.hide()

#=====SIGNALS=====#

func _on_PlayAgain_mouse_entered():
	play_again_selector.visible_characters = -1
	pass # Replace with function body.

func _on_PlayAgain_mouse_exited():
	play_again_selector.visible_characters = 0
	pass # Replace with function body.

func _on_Quit_mouse_entered():
	quit_selector.visible_characters = -1
	play_again_selector.visible_characters = 0
	pass # Replace with function body.

func _on_Quit_mouse_exited():
	quit_selector.visible_characters = 0
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.

func _on_PlayAgain_pressed():
	emit_signal("play_again")
	hide_menu()
#	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_PressStartTimer_timeout():
	if blink:
		start.modulate = Color(1,1,1)
	else:
		start.modulate = Color(0,0,0)
	blink = !blink
	pass # Replace with function body.

func _on_Start_pressed():
	emit_signal("start_game")
	$MainMenu.hide()
	pass # Replace with function body.
