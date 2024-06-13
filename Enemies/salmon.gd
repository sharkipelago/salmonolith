extends PathFollow3D

var speed = GameData.enemy_data["Salmon"].speed

func _ready():
	#progress = 0
	pass
	
func _physics_process(delta):
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta )

