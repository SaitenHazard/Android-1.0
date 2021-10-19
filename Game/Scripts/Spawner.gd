extends Node2D

export var max_ghosts : int = 1
var clock_range : Vector2 = Vector2(0,3)

onready var orb_r = load('res://Scene/Ghost/Orb.tscn')
onready var wisp_r = load('res://Scene/Ghost/Wisp.tscn')

onready var Ghosts = get_node('/root/Control/Ghosts')

onready var GameTimer = get_node('/root/Control/GameTimer')

var can_spawn = true

func _process(delta):
	_spawn_manager()
	_end_game_manager()
	
func _end_game_manager():
	if GameTimer.is_stopped():
		Ghosts.queue_free()
		self.queue_free()
	
func _spawn_manager():
	if Ghosts == null:
		return
		
	var ghost_count = Ghosts.get_child_count()
	
	if can_spawn and ghost_count < max_ghosts:
		can_spawn = false
		_spawn()
		_set_clock()

func _spawn():
#	var ghost = orb_r.instance()
	var ghost = wisp_r.instance()
	ghost.global_position = self.global_position
	Ghosts.add_child(ghost)

func _set_clock():
	RandomNumberGenerator.new()
	var clock = rand_range(clock_range.x,clock_range.y)
	$Timer.start(clock)

func _on_Timer_timeout():
	can_spawn = true
