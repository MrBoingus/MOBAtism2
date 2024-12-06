extends Node3D
class_name TowerProjectile

@onready var target

@onready var speed = 15
@onready var damage = 100

func _ready() -> void:
	print("im alive")

func _process(delta: float) -> void:
	if target: look_at(target.global_position)
	if "center" in target:
		global_position = global_position.move_toward(target.center.global_position, speed * delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != target:
		print("hit something, but not my target")
	else:
		print("hit target!")
		target.GetHit(damage)
		queue_free()
