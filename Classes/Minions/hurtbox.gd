extends Area3D
class_name MinionHurtbox

@onready var minion : Minion

func _ready() -> void:
	await owner.ready
	minion = owner

func GetHit(attacker:TestCharacter, damage:float):
	minion.health -= damage
	
	if minion.health <= 0:
		minion.Die(attacker)
