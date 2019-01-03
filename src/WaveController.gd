extends Node

# class member variables go here, for example:
onready var enemies_container = get_node("/root/Root/Enemies")
var enemy = preload("res://BasicEnemy.tscn")

export (Array) var enemies_per_wave
export (float) var seconds_between_enemies

var enemies_spawned = 0
var time_since_last_spawn = 0
var wave = 0

func _process(delta):
	if enemies_spawned < enemies_per_wave[wave]:
		time_since_last_spawn += delta

		if time_since_last_spawn >= seconds_between_enemies:
			var new_enemy = enemy.instance()
			enemies_container.add_child(new_enemy)
			enemies_spawned += 1
			time_since_last_spawn = 0
