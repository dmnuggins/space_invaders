extends Node


var save_data = {
	"high_score": 0
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save():
	var saveFile = File.new()
	saveFile.open("user://high_score.data", File.WRITE)
	saveFile.store_line(to_json(save_data))
	saveFile.close()

func load():
	var saveFile = File.new()
	if not saveFile.file_exists("user://high_score.data"):
		save()
		return
	saveFile.open("user://high_score.data", File.READ)
	var data = parse_json(saveFile.get_as_text())
	
	save_data.high_score = data.high_score

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
