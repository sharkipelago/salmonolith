extends Node

func _ready():
	load_main_menu()

func load_main_menu():
	get_node("MainMenu/Margins/VBox/NewGame").pressed.connect(on_new_game_pressed)
	get_node("MainMenu/Margins/VBox/Quit").pressed.connect(on_quit_pressed)
	
func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = preload("res://game_scene.tscn").instantiate()
	game_scene.game_finished.connect(unload_game)
	add_child(game_scene)
	
func on_quit_pressed():
	get_tree().quit()

func unload_game(won_game):
	get_node("GameScene").queue_free()
	var main_menu = load("res://Menus/main_menu.tscn").instantiate()
	add_child(main_menu)
	load_main_menu()
	

