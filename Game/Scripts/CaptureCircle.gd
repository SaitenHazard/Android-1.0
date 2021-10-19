extends Node2D

var points_line = PoolVector2Array()
var points_shape = PoolVector2Array()
var point_index : int = 0
var touch_position : Vector2
var line_lenght : int = 0

onready var line = $Line2D
onready var afterLine = $AfterLine2D
var max_line_length : int = 200
var lenght_between_points : int = 5

var shape_begin_index : int
var segment_segment_intersection : Vector2

var shape_set : bool = false

onready var label = get_node('/root/World/Control/Label')

enum TOUCH_STATE {PRESSED, JUST_PRESSED, RELEASED}

var state

func get_max_line_length():
	return max_line_length
	
func get_line_length():
	return line_lenght

func _process(delta):
	_animate_afterLight()
	_draw_line()
	_find_segment_segment_intersection()
	_find_segemnt_ghost_intersection()
	
func _animate_afterLight():
	if afterLine.default_color.a == 0:
		return
	
	var color_alpha =  lerp(afterLine.default_color.a, 0 , 0.1)
	afterLine.default_color = Color(afterLine.default_color.r, 
	afterLine.default_color.g, afterLine.default_color.b, color_alpha)
	
func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		state = TOUCH_STATE.JUST_PRESSED
		touch_position = get_canvas_transform().xform_inv(event.position)
	
	elif event is InputEventScreenDrag:
		state = TOUCH_STATE.PRESSED
		touch_position = get_canvas_transform().xform_inv(event.position)
		
	else:
		if not OS.get_name() == "Windows":
			state = TOUCH_STATE.RELEASED
	
func _initialize_draw_line():
	points_line = PoolVector2Array()
	point_index = 0
	line_lenght = 0
		
func _find_ghost_inside_shape():
	var ghosts = get_node('/root/Control/Ghosts').get_children()
	for ghost in ghosts:
		var is_in_polygon = Geometry.is_point_in_polygon(ghost.get_global_position(), points_shape)
		if is_in_polygon:
			ghost.get_hit()
			
	points_shape = PoolVector2Array()
	
func _draw_line():
	if line_lenght < max_line_length:
		if state == TOUCH_STATE.JUST_PRESSED:
			points_line.append(touch_position)
		if state == TOUCH_STATE.PRESSED:
			if points_line.size() == 0:
				points_line.append(touch_position)
			if points_line[point_index].distance_to(touch_position) > lenght_between_points:
				line_lenght = line_lenght + lenght_between_points
				points_line.append(touch_position)
				point_index +=1
			
	if state == TOUCH_STATE.RELEASED:
		_initialize_draw_line()
	
	line.points = points_line

func _draw_shape():
	points_shape = PoolVector2Array()
	points_shape.append(segment_segment_intersection)
	
	for x in range(shape_begin_index, points_line.size()-2):
		points_shape.append(points_line[x])
	points_shape.append(segment_segment_intersection)
	shape_set = true
	
	line.points = PoolVector2Array()
	
	afterLine.default_color = Color(afterLine.default_color.r, 
	afterLine.default_color.g, afterLine.default_color.b, 1)
	afterLine.points = points_shape

func _find_segment_segment_intersection():
	if points_line.size() < 3:
		return
		
	var latest_segment_from = points_line[points_line.size()-1]
	var latest_segment_to = points_line[points_line.size()-2]
	
	for x in (points_line.size() - 4):
		var segment_from = points_line[x]
		var segment_to = points_line[x+1]
		var intersection = Geometry.segment_intersects_segment_2d(
			latest_segment_from, latest_segment_to, segment_from, segment_to)
			
		if not intersection == null:
			shape_begin_index = x+1
			segment_segment_intersection = intersection
			_draw_shape()
			_find_ghost_inside_shape()
			_initialize_draw_line()
			return

func _find_segemnt_ghost_intersection():
	if points_line.size() < 2:
		return
		
	if (get_node('/root/Control/Ghosts') == null):
		return
		
	var ghosts = get_node('/root/Control/Ghosts').get_children()
	
	for x in (points_line.size() - 1):
		var segment_from = points_line[x]
		var segment_to = points_line[x+1]
		
		for ghost in ghosts:
			if ghost.has_method('get_appear'):
				if not ghost.get_appear():
					continue
			
			var circle_posiiton = ghost.global_position
			var circle_radius = ghost.get_circle_radius()
	
			var critter_found = Geometry.segment_intersects_circle (
				segment_from, segment_to, circle_posiiton, circle_radius)
	
			if not critter_found == -1:
#				critter_crossed_segement = true
				get_node('/root/Control/Score').add_score(-1)
				_initialize_draw_line()
				_do_floating_text(circle_posiiton)
				return

var floaty_text_scene = preload("res://Scene/FloatingText.tscn")
	
func _do_floating_text(position):
	var floaty_text = floaty_text_scene.instance()
	floaty_text.initialize(position, -1)
	get_tree().root.add_child(floaty_text)
