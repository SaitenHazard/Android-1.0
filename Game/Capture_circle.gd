extends Node2D

var points_line = PoolVector2Array()
var points_shape = PoolVector2Array()
var points_use = PoolVector2Array()
var index : int = 0
onready var line = $Line2D

#var pointA2Index : Vector2
#var pointB1Index : Vector2
#var pointB2 : Vector2
var shape_begin_index : int
var pointC : Vector2

var instersection_found : bool = false
var shape_set : bool = false

func _process(delta):
	_draw_line()
	_find_intersecting_point()
	_draw_shape()
	_find_critter_inside_shape()
	line.points = points_use

var temp2 : bool = false

func _find_critter_inside_shape():
	if not instersection_found:
		return
		
	if temp2:
		return
		
	var critters = get_node('/root/World/Critters').get_children()
	
	for x in critters.size():
		var temp = Geometry.is_point_in_polygon(critters[x].get_global_position(), points_use)
		if temp:
			print(temp)
			temp2 = true
	
func _draw_line():
	if instersection_found:
		return
	
	points_use = points_line
		
	if Input.is_action_just_pressed("Press"):
		points_line.append(get_global_mouse_position())
	if Input.is_action_pressed("Press"):
		if points_line[index].distance_to(get_global_mouse_position()) > 30:
			points_line.append(get_global_mouse_position())
			index +=1

func _draw_shape():
	if not instersection_found:
		return
	
	points_shape.append(pointC)
	
	for x in range(shape_begin_index, points_line.size()-2):
		points_shape.append(points_line[x])
		
	points_shape.append(pointC)
	points_use = points_shape
		
	shape_set = true

func _find_intersecting_point():
	if instersection_found:
		return
	
	if points_line.size() < 3:
		instersection_found = false
		return
		
	var pointA1 = points_line[points_line.size()-1]
	var pointA2 = points_line[points_line.size()-2]
	
	for x in (points_line.size() - 4):
		shape_begin_index = x+1
		var pointB1 = points_line[x]
		var pointB2 = points_line[shape_begin_index]
		var temp = Geometry.segment_intersects_segment_2d(pointA1, pointA2, pointB1, pointB2)
		if not temp == null:
			pointC = temp
			instersection_found = true
			return
			
	instersection_found = false
