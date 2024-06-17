extends PathFollow3D

var stats = GameData.enemy_data["Salmon"]
var speed = GameData.enemy_data["Salmon"].speed
var max_hp = GameData.enemy_data["Salmon"].max_hp
var hp = GameData.enemy_data["Salmon"].max_hp
	
@export var green_health_material : Material
@export var yellow_health_material : Material
@export var red_health_material : Material

signal damage_rock

func _ready():
	update_health_bar()
	
func _physics_process(delta):
	if progress_ratio == 1.0:
		damage_rock.emit(stats.rock_damage)
		die()
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta )

func on_hit(damage):
	print("Hit for:" + str(damage))
	hp -= damage
	update_health_bar()
	if hp <= 0:
		die()
		
func die():
	self.queue_free()
	
func update_health_bar():
	if hp > max_hp/2:
		$HealthBar.material_override = green_health_material
	elif hp > max_hp/4:
		$HealthBar.material_override = yellow_health_material
	else:
		$HealthBar.material_override = red_health_material
