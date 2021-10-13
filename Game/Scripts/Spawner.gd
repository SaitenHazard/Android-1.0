extends Node2D

export var max_critter : int = 1
var clock_range : Vector2 = Vector2(0,3)

onready var critter_r = load('res://Scene/Critter.tscn')
onready var Critters = get_node('/root/Control/Critters')

onready var GameTimer = get_node('/root/Control/GameTimer')

var can_spawn = true

func _process(delta):
	_spawn_manager()
	_end_game_manager()
	
func _end_game_manager():
	if GameTimer.is_stopped():
		Critters.queue_free()
		self.queue_free()
	
func _spawn_manager():
	if Critters == null:
		return
		
	var critter_count = Critters.get_child_count()
	
	if can_spawn and critter_count < max_critter:
		can_spawn = false
		_spawn()
		_set_clock()

func _spawn():
	var critter = critter_r.instance()
	critter.global_position = self.global_position
	Critters.add_child(critter)

func _set_clock():
	RandomNumberGenerator.new()
	var clock = rand_range(clock_range.x,clock_range.y)
	$Timer.start(clock)

func _on_Timer_timeout():
	can_spawn = true
