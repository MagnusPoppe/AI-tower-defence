extends Node2D

# Preloaded variables: 
onready var enemy_troops = get_node("/root/Root/Enemies")
onready var projectiles_container = get_node("/root/Root/Projectiles")
var default_projectile = preload("res://BasicProjectile.tscn")

# User set parameters:
export (float) var shooting_range
export (float) var reload_time
export (int) var damage

var projectiles = []
var reload_timer = 0

func _process(delta):
	reload_timer -= delta

	var closest_enemy = null
	var distance = null
	for enemy in enemy_troops.get_children():
		var dist = position.distance_to(enemy.position)
		if not distance or dist < distance:
			closest_enemy = enemy
			distance = dist


	if closest_enemy != null and distance < shooting_range:
		rotation = position.angle_to_point(closest_enemy.position)

		if reload_timer <= 0:
			var projectile = default_projectile.instance()
			projectile.setup(self.position, closest_enemy.position, self.damage)
			projectiles_container.add_child(projectile)
			reload_timer = reload_time
			

