extends Node
class_name TesteeAttackHandler

@onready var player : TestCharacter

@onready var attackTimer : Timer = $BasicAttackTimer


func _ready() -> void:
	await owner.ready
	player = owner
	
	CalculateAttackTimer(player.baseStats.baseAttackSpeed)

# Below code is basically only for targeted attacks.
func DeclareAttack(_creator, _victim, _attack):
	if player.global_position.distance_to(player.target.global_position) <= player.baseStats.baseAttackRange:
		if player.target and player.target.has_method("GetHit"):
			player.target.GetHit(player, player.baseStats.baseAttackDamage, null)
			attackTimer.start()
		

#NOTE: Basic attack timer should be equal to 1/attack speed , like so:
#0.8 attack speed (0.8 attacks per second):
	#1/0.8 = 1.25 seconds between attacks
#Minimum attack speed in league is 0.2:
	#1/0.2 = 5
#Maximum attack speed is 2.5:
	#1/2.5 = 0.4
func CalculateAttackTimer(newSpeed):
	$BasicAttackTimer.wait_time = 1/newSpeed
