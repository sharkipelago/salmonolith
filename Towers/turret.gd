extends Node3D

var island_center = Vector3(0.5, 4.5, 1.5)

func _physics_process(delta):	 
	update_island_center(delta)
	turn()
	
func turn():
	var enemy_position = island_center
	get_node("Turret").look_at(Vector3(enemy_position.x, position.y, enemy_position.z), Vector3.UP, true)


var moving_right = true
var speed = 2
var upper_bound = 4
var lower_bound = -3

func update_island_center(delta):
	if island_center.x > upper_bound:
		moving_right = false
	if island_center.x < lower_bound:
		moving_right = true
	
	var x_dest = upper_bound + .5
	if !moving_right:
		x_dest = lower_bound - .5	
	island_center = island_center.move_toward(Vector3(x_dest, 4.5, 1.5), delta * speed)
	

