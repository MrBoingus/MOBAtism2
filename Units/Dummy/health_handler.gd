extends Node

@onready var dummy : Dummy

func _ready() -> void:
	await owner
	dummy = owner

func TakeDamage(damage : float):
	dummy.health -= damage
	
	if dummy.health <= 0:
		dummy.queue_free()
		dummy.lastAttacker.target = null
		dummy.lastAttacker.ReceiveExperience(dummy.experienceValue)
