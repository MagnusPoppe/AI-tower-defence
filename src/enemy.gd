extends KinematicBody2D

# User preference variables: 
export (float) var speed
export (int) var max_hp

# Travel path variables: 
var road_scene = preload("res://Road.tscn")
var pid = 0
var path = []

# Stats:
var remaining_hp
var velocity = Vector2(0, 0)


func _ready():
	# Getting road skeleton:
	var road = road_scene.instance()
	road.position = Vector2(0,0)
	path = road.get_child(1).points

	# Setting my self to start.
	position = path[pid]

	# Setup for my stats:
	remaining_hp = max_hp
	

func _physics_process(delta):
	# Checking if my destination is reached: 
	if self.destination_reached():
		pid += 1
		if pid < len(path):
			self.rotation = self.position.angle_to_point(path[pid])
			self.velocity = Vector2(-speed, 0).rotated(self.rotation)
		else:
			var wave_controller = get_node("/root/Root/WaveController")
			wave_controller.deduct_point(remaining_hp)
			self.queue_free()
	
	# Finally moving:
	move_and_slide(self.velocity)


func destination_reached():
	return  ( 	# Exactly at destination: 
		int(position.x) == int(path[pid].x) && 
		int(position.y) == int(path[pid].y)
	) || ( 		# Passed destination
		(
			(velocity.x < 0 && position.x <= path[pid].x) ||
			(velocity.x > 0 && position.x >= path[pid].x)
		) && (
			(velocity.y < 0 && position.y <= path[pid].y) ||
			(velocity.y > 0 && position.y >= path[pid].y)
		)
	)


func hit(damage):
	# UGH!
	remaining_hp -= damage

	# Should i be alive?
	if self.remaining_hp <= 0:
		self.queue_free()