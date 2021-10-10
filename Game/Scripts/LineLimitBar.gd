extends ProgressBar

var max_line_length
var line_length

onready var CaptureCircle = get_node('/root/Control/CaptureCircle')

func _process(delta):
	max_line_length = CaptureCircle.get_max_line_length()
	line_length = CaptureCircle.get_line_length()

	self.max_value = max_line_length
	self.value = max_line_length - line_length
