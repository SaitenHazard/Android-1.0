extends Node2D

var points_line = PoolVector2Array()
var points_shape = PoolVector2Array()
var point_index : int = 0
var touch_position : Vector2
var line_lenght : int = 0

onready var line = $Line2D
onready var afterLine = $AfterLine2D
#onready var polygon = $Polygon2D
var max_line_length : int = 2000

#var pointA2Index : Vector2
#var pointB1Index : Vector2
#var pointB2 : Vector2
var shape_begin_index : int
var pointC : Vector2

#var draw_shape : bool = false
var shape_set : bool = false

onready var label = get_node('/root/World/Control/Label')

enum STATES {PRESSED, JUST_PRESSED, RELEASED}

var state

func get_max_line_length():
	return max_line_length
	
func get_line_length():
	return line_lenght

func _process(delta):
	_plot_line()
	_find_intersecting_point()
	_plot_shape()
	_find_critter_inside_shape()
	_draw_line()
#	_draw_shape()

func _draw_line():
#	if draw_shape:
#		return
		
	line.points = points_line
	
func _draw_shape():
#	if not draw_shape:
#		return
	
	line.points = PoolVector2Array()
	afterLine.points = points_shape
#	polygon.set_polygon(points_shape)

	
func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		state = STATES.JUST_PRESSED
		touch_position = get_canvas_transform().xform_inv(event.position)
	
	elif event is InputEventScreenDrag:
		state = STATES.PRESSED
		touch_position = get_canvas_transform().xform_inv(event.position)
		
	else:
		if not OS.get_name() == "Windows":
			state = STATES.RELEASED
	
#func _debug():
#	if state == STATES.JUST_PRESSED:
#		print('JUST PRESSED')
##		label.text = 'JUST PRESSED'
#
#	if state == STATES.PRESSED:
#		print('PRESSED')
##		label.text = 'PRESSED'
#
#	if state == STATES.RELEASED:
#		print('RELEASED')
##		label.text = 'RELEASED'

func _initialize_draw_line():
	points_line = PoolVector2Array()
#	draw_shape = false
	point_index = 0
	line_lenght = 0
		
func _find_critter_inside_shape():
#	if not draw_shape:
#		return
		
	var critters = get_node('/root/Control/Critters').get_children()
	for x in critters.size():
		var is_in_polygon = Geometry.is_point_in_polygon(critters[x].get_global_position(), points_shape)
		if is_in_polygon:
			critters[x].get_hit()
	
func _plot_line():
#	if draw_shape:
#		return
		
	if line_lenght < max_line_length:
		
		if state == STATES.JUST_PRESSED:
			points_line.append(touch_position)
			
		if state == STATES.PRESSED:
			if points_line.size() == 0:
				points_line.append(touch_position)
			
			if points_line[point_index].distance_to(touch_position) > 10:
				line_lenght = line_lenght + 10
				points_line.append(touch_position)
				point_index +=1
			
	if state == STATES.RELEASED:
		points_line = PoolVector2Array()
		
func _plot_shape():
#	if not draw_shape:
#		return
	
	points_shape = PoolVector2Array()
	points_shape.append(pointC)
	
	for x in range(shape_begin_index, points_line.size()-2):
		points_shape.append(points_line[x])
		
	points_shape.append(pointC)
	shape_set = true

func _find_intersecting_point():
#	if draw_shape:
#		return
	
	if points_line.size() < 3:
#		draw_shape = false
		return
		
	var pointA1 = points_line[points_line.size()-1]
	var pointA2 = points_line[points_line.size()-2]
	
	for x in (points_line.size() - 4):
		shape_begin_index = x+1
		var pointB1 = points_line[x]
		var pointB2 = points_line[shape_begin_index]
		var found = Geometry.segment_intersects_segment_2d(pointA1, pointA2, pointB1, pointB2)
		if not found == null:
			pointC = found
			_plot_shape()
			_draw_shape()
			_initialize_draw_line()
#			draw_shape = true
			return
			
#	draw_shape = false

