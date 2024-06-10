@tool
extends MeshInstance3D

# https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/arraymesh.html
# https://www.youtube.com/watch?v=8wy_dH9RLI4

@export var update = false
@export var save = false
@export var mesh_name : String = "custom_mesh"

var radius = 0.5
var segments = 72


func _ready():
	gen_mesh()
	
func _process(delta):
	if update:
		gen_mesh()
		update = false
	if save:
		save_mesh()
		save = false

func save_mesh():
	ResourceSaver.save(mesh, "res://" + mesh_name + ".tres", ResourceSaver.FLAG_COMPRESS)
	
	
func gen_mesh():
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	# PackedVector**Arrays for mesh construction.
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()

	
	# https://www.reddit.com/r/godot/comments/hw05sd/circle_plane/
	uvs.append(0.5 * Vector2.ONE)
	verts.append(Vector3.ZERO) # center of circle
	
	for i in range(segments + 1):
		var angle = i / float(segments) * TAU
		var p = Vector3.RIGHT.rotated(Vector3.DOWN, angle)
		
		var uv = 0.5 * (Vector2(p.x, p.z) + Vector2.ONE)
		var position = radius * p
		
		uvs.append(uv)
		verts.append(position)
		
		if i == 0: 
			continue
		indices.append_array(PackedInt32Array([0, i, i + 1]))
	

	print(indices)
	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	#surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices

	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	mesh = array_mesh
	return array_mesh
	
	
