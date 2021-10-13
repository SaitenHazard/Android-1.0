extends Node2D

var captured : bool = false

export var health_max : float = 2
#export var circle_radius : float = 18

var health_current : float
var limits_min = Vector2(50, 40)
var limits_max = Vector2(880, 460)

#func get_circle_radius() -> float:
#	return circle_radius

func _ready():
	health_current = health_max
	$ProgressBar.max_value = health_max

func get_hit():
	if health_current == 0:
		return
		
	health_current = health_current -1
	_ani_hit()

func _process(delta):
	$ProgressBar.value = health_current
	_do_death()
	_move()
	
var movement_direction : Vector2 = Vector2()
var min_position : Vector2 = Vector2(80, 50)
var max_position : Vector2 = Vector2(900, 420)

var speed = 2
	
func _move():
	if $TimerMovement.is_stopped():
		_set_move()
	_correct_out_of_bounds()
	var velocity = movement_direction * speed
	self.position += velocity

func _correct_out_of_bounds():
	if self.global_position.x <= min_position.x and movement_direction.x < 0:
		movement_direction.x = movement_direction.x * -1
		
	if self.global_position.y <= min_position.y and movement_direction.y < 0:
		movement_direction.y = movement_direction.y * -1

	if self.global_position.x >= max_position.x and movement_direction.x > 0:
		movement_direction.x = movement_direction.x * -1
#
	if self.global_position.y >= max_position.y and movement_direction.y > 0:
		movement_direction.y = movement_direction.y * -1
	
func _set_move():
	RandomNumberGenerator.new()
	var clock = rand_range(1,5)
	$TimerMovement.start(clock)
	movement_direction.x = rand_range(-1,1)
	movement_direction.y = rand_range(-1,1)
	movement_direction = movement_direction.normalized()

func _ani_hit():
	$Sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.15), "timeout")
	$Sprite.material.set_shader_param("flash_modifier", 0)
	
func _do_death():
	if health_current > 0:
		return
	get_node('/root/Control/Score').add_score()
	_do_destroy()

func _do_destroy():
	$Sprite.material.set_shader_param("flash_color", Color(1,1,1,1))
	$Sprite.material.set_shader_param("flash_modifier", 1)
	$Sprite.scale = lerp($Sprite.scale, Vector2(0,0), 0.1)
	self.queue_free()
