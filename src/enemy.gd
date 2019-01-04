extends KinematicBody2D

# User preference variables: 
export (float) var speed
export (int) var max_hp

# Travel path variables: 
onready var target_container = get_node("/root/Root/Health")
onready var start = get_node("/root/Root/BackgroundGraphics/Beach")
var pid = 0
var target = null
var path = []

# Stats:
var intelligence_level = 0
var remaining_hp
var velocity = Vector2(0, 0)


func _ready():
	# Getting road skeleton:
	path.push_back(start.position)
	self.position = path[pid]
	select_target()
	
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

func select_target():
	var targets = target_container.get_children()
	target = targets[randi() % len(targets)]
	if intelligence_level == 0:
		path.push_back(target.position)


func destination_reached():
	# :Returns: True if destination is reached or passed
	return  (
		(
			(velocity.x <= 0 && position.x <= path[pid].x) ||
			(velocity.x >= 0 && position.x >= path[pid].x)
		) && (
			(velocity.y <= 0 && position.y <= path[pid].y) ||
			(velocity.y >= 0 && position.y >= path[pid].y)
		)
	)


func hit(damage):
	# UGH!
	remaining_hp -= damage

	# Should i be alive?
	if self.remaining_hp <= 0:
		self.queue_free()