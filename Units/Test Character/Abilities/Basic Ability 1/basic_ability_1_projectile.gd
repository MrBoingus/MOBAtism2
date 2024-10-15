extends CharacterBody3D

@onready var lifetime = 0
@onready var maxLifetime = 40

@onready var speed = 35

func _ready() -> void:
	print_debug("ability spawned")

func _process(delta: float) -> void:
	lifetime += 1
	
	if lifetime >= maxLifetime:
		queue_free()
	else:
		velocity = -transform.basis.z * speed
		move_and_slide()
