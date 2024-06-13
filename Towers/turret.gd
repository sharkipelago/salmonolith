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
	# Note this tracks how far they've been not how far they have left to go, when implementing multiple paths
	# better to see how far they have left to go, bc different paths could have differnet lengths
	# E.g. A has gone 1m, still has 3m left to go, B has gone 0m, still has 1m left to go on different path
	# Probably want to target B, right?
	
	var enemy_progress = []
	for enemy in enemies_in_range:
		enemy_progress.append(enemy.get_progress())
	var max_progress = enemy_progress.max()
	enemy = enemies_in_range[enemy_progress.find(enemy_progress)]

func turn():
	var target = enemy.global_position
	print(target)
	get_node("Turret").look_at(Vector3(target.x, position.y, target.z), Vector3.UP, true)


func _on_range_body_entered(body):
	enemies_in_range.append(body.get_parent()) #get_parent() so appends follow instead of body
	
func _on_range_body_exited(body):
	enemies_in_range.erase(body.get_parent()) #get_parent() so appends follow instead of body


