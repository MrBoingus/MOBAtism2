extends Node

@onready var dummy : Dummy
var healthBar : ProgressBar
var manaBar : ProgressBar

func _ready() -> void:
	await owner.ready
	dummy = owner

func TakeDamage(damage : float):
	dummy.health -= damage
	healthBar.value = dummy.health
	
	if dummy.health <= 0:
		dummy.queue_free()
		dummy.lastAttacker.target = null
		dummy.lastAttacker.ReceiveExperience(dummy.experienceValue)
