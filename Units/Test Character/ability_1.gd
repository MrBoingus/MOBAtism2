extends StateConnector

@onready var projectile = preload("res://Units/Test Character/Abilities/Basic Ability 1/BasicAbility1Projectile.tscn")

func enter():
	var spawn = projectile.instantiate()
	var mousePosition = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	
	var rayOrigin = camera.project_ray_origin(mousePosition)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePosition) * 9999
	var ray = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	ray.set_collide_with_areas(true)
	var layer = 4
	ray.set_collision_mask(pow(2, layer - 1))
	var rayWorld = player.get_world_3d().direct_space_state.intersect_ray(ray)
	if rayWorld:
		var pos = rayWorld.position
		pos.y = 0
		player.look_at(pos)
	
	add_child(spawn)
	player.abilityHandler.basicAbilityTimer_1.start()
	#player.abilityHandler.timers[1].start()
	
	spawn.transform = player.global_transform
	spawn.position = player.position
