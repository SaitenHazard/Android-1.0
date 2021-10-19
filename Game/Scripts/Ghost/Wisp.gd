extends ORb

var appear : bool = false

func get_appear() -> bool: 
	return appear
	
func _process(delta):
	appear = true
	
func _disappear():
	if $TimerDisappear.is_stopped():
		_set_disappear()
	
	var interpolate_to
		
	if appear:
		interpolate_to = 1
	else:
		interpolate_to = .5
		
	modulate.a = lerp(modulate.a, interpolate_to, 0.1)

func _set_disappear():
	RandomNumberGenerator.new()
	var clock = rand_range(3,6)
	$TimerDisappear.start(clock)
	appear = !appear

#func get_hit():
#	if not appear:
#		return
#
#	.get_hit()
