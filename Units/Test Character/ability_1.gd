extends StateConnector

@onready var projectile = preload("res://Units/Test Character/Abilities/Basic Ability 1/BasicAbility1Projectile.tscn")

func enter():
	var spawn = projectile.instantiate()
	spawn.position = player.position + Vector3(-0.5, 0, 0)
	add_child(spawn)
	print(player.global_position)
	print(spawn.global_position)
