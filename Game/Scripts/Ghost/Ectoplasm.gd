extends ORb

onready var plasma_r = load('res://Scene/Ghost/Plasma.tscn')
onready var Ghosts = get_node('/root/Control/Ghosts')

var eject_plasma_wait_time : float = 0.05

func _ready():
	_eject_plasma()

func _eject_plasma():
	while(true):
		yield(get_tree().create_timer(eject_plasma_wait_time), "timeout")
		var plasma = plasma_r.instance()
		Ghosts.add_child(plasma)
		plasma.global_position = $EjectPosition.global_position
