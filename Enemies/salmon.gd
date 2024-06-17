extends PathFollow3D

var speed = GameData.enemy_data["Salmon"].speed
var max_hp = GameData.enemy_data["Salmon"].max_hp
var hp = GameData.enemy_data["Salmon"].max_hp
	
@export var green_health_material : Material
@export var yellow_health_material : Material
@export var red_health_material : Material

func _ready():
	update_healthbar()
	
func _physics_process(delta):
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta )

func on_hit(damage):
	print("Hit for:" + str(damage))
	hp -= damage
	update_healthbar()
	if hp <= 0:
		die()
		
func die():
	self.queue_free()
	
func update_healthbar():
	if hp > max_hp/2:
		$Healthbar.material_override = green_health_material
	elif hp > max_hp/4:
		$Healthbar.material_override = yellow_health_material
	else:
		$Healthbar.material_override = red_health_material
