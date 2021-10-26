extends Node2D

class_name ORb

var captured : bool = false

export var health_max : float = 2.0
export var circle_radius : float = 18.0
export var reward_score : int = 5.0
var speed : float = 1.0

var health_current : float

var limits_min = Vector2(50, 40)
var limits_max = Vector2(880, 460)
var min_position : Vector2 = Vector2(80, 50)
var max_position : Vector2 = Vector2(900, 420)

var movement_direction : Vector2 = Vector2()

func get_circle_radius() -> float:
	return circle_radius

func _ready():
	health_current = health_max
	$ProgressBar.max_value = health_max
	$Sprite.z_index = 200

func get_hit():
	if health_current == 0:
		return
		
	health_current = health_current -1
	_ani_hit()

func _process(delta):
	$ProgressBar.value = health_current
	_do_death()
	_move()
	_move_ani()
	
func _move_ani():
	if movement_direction.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
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
	var clock = rand_range(1,4)
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
		
	get_node('/root/Control/Score').add_score(5)
	_do_floating_text()
	_do_destroy()
	
var floaty_text_scene = preload("res://Scene/FloatingText.tscn")
	
func _do_floating_text():
	var floaty_text = floaty_text_scene.instance()
	floaty_text.initialize(self.global_position, reward_score)
	get_tree().root.add_child(floaty_text)

func _do_destroy():
	$Sprite.material.set_shader_param("flash_color", Color(1,1,1,1))
	$Sprite.material.set_shader_param("flash_modifier", 1)
	$Sprite.scale = lerp($Sprite.scale, Vector2(0,0), 0.1)
	self.queue_free()
