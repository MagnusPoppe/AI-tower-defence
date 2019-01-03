extends KinematicBody2D

# class member variables go here, for example:
var step = 0.0
var speed = 6
var to = null
var velocity = null
var time_alive = 0
var ready = false
var damage = 0

func setup(_from, _to, _damage):
	damage = _damage
	position = _from
	to = _to
	rotation = position.angle_to_point(to)
	velocity = Vector2(-speed, 0).rotated(position.angle_to_point(to))
	ready = true

func _process(delta):
	time_alive += delta
	if time_alive > 3:
		self.queue_free()

func _physics_process(delta):
	if ready:
		var collision = move_and_collide(velocity)
		if collision and collision.collider.has_method("hit"):
			collision.collider.hit(damage)
			self.queue_free()