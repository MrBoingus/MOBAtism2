extends Area3D
class_name Hitbox

@onready var projectile

func _ready() -> void:
	await owner.ready
	projectile = owner
	
	area_entered.connect(OnHitboxEntered)

func OnHitboxEntered(area : DummyHurtbox):
	print(area.name)
	area.GetHit(projectile.creator, projectile.damage)
	owner.queue_free()
