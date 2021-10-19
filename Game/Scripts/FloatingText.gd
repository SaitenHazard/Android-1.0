extends Position2D

onready var tween = $Tween

var velocity = Vector2(50, -100)
var gravity = Vector2(0, 1)
var mass = 200

func _ready():
	tween.interpolate_property(self, "scale", 
		Vector2(0, 0), 
		Vector2(1.0, 1.0),
		0.5, Tween.TRANS_QUART, Tween.EASE_OUT)
	
	tween.interpolate_callback(self, 0.5, "destroy")
	
	tween.start()

func initialize(position : Vector2, score : int):
	var text;
		
	if score < 0:
		$Label.modulate = Color8(221,70,53,255)
		text = '-'
	else:
		text = '+'
		$Label.modulate = Color8(251,249,248,255)
	
	text += String(abs(score))
	
	self.position = position
	$Label.text = text
	self.velocity = Vector2(rand_range(-50, 50), -100)
	
func _process(delta):
	velocity += gravity * mass * delta
	position +=  velocity * delta
#
#func set_text(new_text = '1'):
#	$Label.text = str(new_text)
#
#func get_text():
#	return $Label.text

func destroy():
	queue_free()
