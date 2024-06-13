extends Node

signal initalized_by_game_scene 

var map_node # Needs to be initalized by game scene

var current_wave = 0
var enemies_in_wave

func _ready():
	await initalized_by_game_scene
	start_next_wave()
	

func start_next_wave():
	var wave_data = retrieve_wave_data()
	await get_tree().create_timer(2).timeout
	spawn_enemies(wave_data)

func retrieve_wave_data():
	var wave_data = [["Salmon", 0.7]]#, ["Salmon", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data 
	
func spawn_enemies(wave_data):
	for enemy in wave_data:
		var new_enemy = load("res://Enemies/" + enemy[0].to_lower() + ".tscn").instantiate()
		map_node.get_node("Path").add_child(new_enemy, true)
		await get_tree().create_timer(enemy[1]).timeout

func _on_call_wave_pressed():
	start_next_wave()
