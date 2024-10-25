extends Projectile

@onready var creator

@onready var mesh = $MeshInstance3D

@onready var lifetime = 0
@onready var maxLifetime = 40

@onready var damage = 50

@onready var speed = 27

#func _ready() -> void:
	#print_debug("ability spawned")

#func _physics_process(delta: float) -> void:
	#$Hitbox/CollisionShape3D.force_update_transform()
	#$Hitbox/CollisionShape3D.disabled = true
	#$Hitbox/CollisionShape3D.disabled = false

func _process(delta: float) -> void:
	lifetime += 1
	
	if lifetime >= maxLifetime:
		queue_free()
	else:
		velocity = -transform.basis.z * speed
		move_and_slide()
