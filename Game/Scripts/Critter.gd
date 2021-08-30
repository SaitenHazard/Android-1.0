extends Sprite

var captured : bool = false

export var health_max : float
var health_current : float

func _ready():
	health_current = health_max
	$ProgressBar.max_value = health_max

func get_hit():
	print(health_current)
	if health_current == 0:
		return
		
	health_current = health_current -1
	if health_max <= 0:
		health_max = 0
		_do_death()
	
func _process(delta):
	$ProgressBar.value = health_current
	_do_death()
	
func _do_death():
	if health_current > 0:
		return
	
	self.material.set_shader_param("flash_color", Color(1,1,1,1))
	self.material.set_shader_param("flash_modifier", 1)
	self.scale = lerp(self.scale, Vector2(0,0), 0.1)
