extends Area3D
class_name Hitbox

func _ready() -> void:
	area_entered.connect(OnHitboxEntered)

func OnHitboxEntered(area : Area3D):
	print(area.owner.name)
	owner.queue_free()
