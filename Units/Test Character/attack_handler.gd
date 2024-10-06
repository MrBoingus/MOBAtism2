extends Node
class_name TesteeAttackHandler

@onready var player : TestCharacter

func _ready() -> void:
	await owner.ready
	player = owner

# Below code is basically only for targeted attacks.
func DeclareAttack(_creator, _victim, _attack):
	if player.global_position.distance_to(player.target.global_position) <= player.baseStats.baseAttackRange:
		player.target.GetHit(player, player.baseStats.baseAttackDamage)
		
