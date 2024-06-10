extends Node3D

var X_MAX_ROTATION = 5
var X_MIN_ROTATION = -15

var rotation_speed = 100

	
func update_rotation(delta, _w, _a, _s, _d):
	var y_direction = ((_d as int) - (_a as int))
	var x_direction = ((_w as int) - (_s as int)) 
	var rotation_delta = delta * rotation_speed * Vector3(x_direction, y_direction, 0) 
	var new_rotation = rotation_degrees + rotation_delta
	new_rotation.x = clamp(new_rotation.x, X_MIN_ROTATION, X_MAX_ROTATION)
	rotation_degrees = new_rotation
	
func get_mouse_raycast(mouse):
	return $Camera.get_mouse_raycast(mouse)
