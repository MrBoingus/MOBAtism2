extends Area3D

@onready var dummy : Dummy

func _ready() -> void:
	await owner.ready
	dummy = owner

func GetHit(attacker:TestCharacter, damage:float):
	dummy.lastAttacker = attacker
	dummy.healthHandler.TakeDamage(damage)
