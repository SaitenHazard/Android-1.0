extends Label

var score : int = 0

func add_score():
	score = score + 1
	
func _process(delta):
	self.set_text(str(score))
