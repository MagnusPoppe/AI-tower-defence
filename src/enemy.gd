extends KinematicBody2D

# class member variables go here, for example:
var road_scene = preload("res://Road.tscn")
var path = []
var attackers = []
var total_distance = 0
export (float) var speed
export (int) var max_hitpoints
var remaining_hit_points
var movement_speed = 0
var time = 0
var interpolating = false
var start_target = null
var current_target = null
var current_distance = null
var point_in_path = 0
var step = 0.0

func _ready():
	# Getting road skeleton:
	var road = road_scene.instance()
	road.position = Vector2(0,0)
	road.get_child(1)
	path = road.get_child(1).points

	# Setting my self to start.
	remaining_hit_points = max_hitpoints
	position = path[point_in_path]
	# Pre calculating total distance
	for i in range(1, len(path)):
		total_distance += path[i-1].distance_to(path[i])
	# Setting self to start.
	get_next_point()

func _process(delta):
	if remaining_hit_points <= 0:
		print("I died!")
		self.queue_free()
	step += movement_speed
	if step <= 1.0:
		position = start_target.linear_interpolate(current_target, step)
	else: 
		step = 0.0
		get_next_point()

func get_next_point():
	start_target = path[point_in_path]
	point_in_path += 1

	if point_in_path >= len(path):
		point_in_path = 0
		position = path[0]
		get_next_point()
	
	current_target = path[point_in_path]
	movement_speed = speed * (1 - (start_target.distance_to(current_target) / total_distance))
	rotation = start_target.angle_to_point(current_target)

func hit(damage):
	remaining_hit_points -= damage
	print("I was hit! Remaining HP: ", remaining_hit_points)
