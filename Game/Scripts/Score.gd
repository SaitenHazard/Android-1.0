extends Label

var score : int = 0

func add_score(add_this = 1):
	score = score + add_this
	
func _process(delta):
	self.set_text(str(score))
