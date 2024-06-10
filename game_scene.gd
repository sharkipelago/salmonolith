extends Node

var BLOCK_INDEX = 3 # The only gridmap element on which towers can be built
var EMPTY_BLOCK_INDEX = 116

var island_grid
var build_bar

var tower_previews = {} # All tower previews
var active_tower_preview = null # Current tower preview
var build_location = null

# Input
var mouse_position = Vector2()
var mouse_right_button = false
var a_key = false
var d_key = false
var w_key = false
var s_key = false

func _ready():
	island_grid = get_node("Map1/Island")
	build_bar = get_node("UI/HUD/BuildBar")
	build_bar.visible = false
	
	var tower_preview_node = get_node("TowerPreviews")
	var greyed_material = preload("res://Assets/Materials/greyed_tower.tres")
	for bb in get_tree().get_nodes_in_group("build_button"):
		var tower = load("res://Towers/" +  bb.name.to_lower() + "_t1.tscn").instantiate()
		tower.get_node("Turret").material_overlay = greyed_material
		tower.get_node("RangeIndicator").scale += Vector3(2,2,2) * GameData.tower_data[bb.name + "T1"].range
		print(tower.get_node("RangeIndicator").scale)
		tower.visible = false
		tower_preview_node.add_child(tower, true)
		tower_previews[bb.name] = tower 
		bb.mouse_entered.connect(preview_tower.bind(bb.name))
		
		bb.pressed.connect(verify_and_build.bind(bb.name))
	
func _process(delta):
	$CameraSet.update_rotation(delta, w_key, a_key, s_key, d_key)

func _input(event):
	if event is InputEventMouse:
		mouse_position = event.position
	if event is InputEventMouseMotion:
		update_build_location()
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				mouse_right_button = event.pressed  
		
		update_build_bar()
		
	if event is InputEventKey:
		match event.keycode:
			KEY_A:
				a_key = event.pressed
			KEY_D:
				d_key = event.pressed
			KEY_W:
				w_key = event.pressed
			KEY_S:
				s_key = event.pressed
		if w_key or a_key or s_key or d_key:
			hide_build_bar()
	
func update_build_location():
	# Do not update the build location while the build bar is out
	if build_bar.visible:
		return
		
	var intersection = get_node("CameraSet").get_mouse_raycast(mouse_position)

	# Mouse is hovering over the ocean or something
	if not intersection:
		clear_build_location()
		return
		

	var cell_location = island_grid.local_to_map(island_grid.to_local(intersection.position))
	
	# Return early if its the same as the current build_location
	if cell_location == build_location:
		return
	
	# Clear previous build_locaiton
	clear_build_location()

	# If cell is empty and there is a grass block underneath it, then set build_location 
	var cell_value = island_grid.get_cell_item(cell_location)
	var cell_beneath_value = island_grid.get_cell_item(cell_location + Vector3i.DOWN)
	if cell_value == -1 and cell_beneath_value == BLOCK_INDEX:
		build_location = cell_location
		island_grid.set_cell_item(cell_location, 107) # Replace this with hover effect
			
func clear_build_location():
	if not build_location:
		return
	island_grid.set_cell_item(build_location, -1)
	build_location = null


func update_build_bar():
	if mouse_right_button and build_location and not build_bar.visible:
		build_bar.position = mouse_position + Vector2(40, -80)
		build_bar.visible = true
	elif mouse_right_button and build_bar.visible:
		hide_build_bar()
		
func hide_build_bar():
	build_bar.visible = false
	if active_tower_preview:
		active_tower_preview.visible = false

func preview_tower(tower_type: String):
	print("Previewing " + tower_type)
	assert(build_location != null)
	print(build_location)
	if active_tower_preview:
		active_tower_preview.visible = false
	active_tower_preview = tower_previews[tower_type]
	active_tower_preview.position = Vector3(build_location) + Vector3(0.5, 0.5, 0.5)
	active_tower_preview.visible = true


func verify_and_build(tower_type: String):
	# Check Money here
	print(tower_type)
	var tower = load("res://Towers/" +  tower_type.to_lower() + "_t1.tscn").instantiate()
	tower.position = Vector3(build_location) + Vector3(0.5, 0.5, 0.5) # Offset to place it on top of the block
	tower.get_node("RangeIndicator").visible = false
	get_node("Towers").add_child(tower, true)
	island_grid.set_cell_item(build_location, EMPTY_BLOCK_INDEX) # to Prevent double building on this spot
	build_location = null
	hide_build_bar()
	
