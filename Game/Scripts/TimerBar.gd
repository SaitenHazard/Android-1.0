extends ProgressBar

onready var GameTimer = get_node('/root/Control/GameTimer')
var wait_time = 10

func _ready():
	self.max_value = wait_time
	self.value = wait_time
	GameTimer.start(wait_time)

func _process(delta):
	self.value = GameTimer.get_time_left()
