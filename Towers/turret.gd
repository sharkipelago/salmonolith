extends Node3D

var tower_name
var stats

var enemies_in_range = [] #Enemies in range
var enemy # current enemy

func _ready():
	stats = GameData.tower_data[tower_name] 
	get_node("Range").scale = Vector3.ONE + (Vector3.ONE) * stats.range

func _physics_process(delta):
	if enemies_in_range.size() != 0:
		select_enemy()
		turn()

func select_enemy():
	enemy = enemies_in_range[0]

func turn():
	var target = enemy.global_position
	print(target)
	get_node("Turret").look_at(Vector3(target.x, position.y, target.z), Vector3.UP, true)


func _on_range_body_entered(body):
	enemies_in_range.append(body)
	
func _on_range_body_exited(body):
	enemies_in_range.erase(body)


