extends CharacterBody3D
class_name Dummy

var health = 550
var lastAttacker
var experienceValue = 50

func _physics_process(delta: float) -> void:
	pass

func GetHit(attacker:TestCharacter, damage:float):
	health -= damage
	lastAttacker = attacker
	
	if health <= 0:
		queue_free()
		lastAttacker.target = null
		lastAttacker.ReceiveExperience(experienceValue)
