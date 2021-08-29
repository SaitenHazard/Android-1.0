extends ProgressBar

var max_line_length
var line_length

#var export CaptureCircle = get_node('/root/World/CaptureCircle')
onready var CaptureCircle = get_node('/root/World/CaptureCircle')

func _ready():
	pass # Replace with function body.

func _process(delta):
	max_line_length = CaptureCircle.get_max_line_length()
	line_length = CaptureCircle.get_line_length()
	
	self.max_value = max_line_length
	self.value = max_line_length - line_length
