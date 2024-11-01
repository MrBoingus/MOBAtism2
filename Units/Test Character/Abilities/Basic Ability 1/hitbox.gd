extends Hitbox

#func _physics_process(delta: float) -> void:
	#$CollisionShape3D.disabled = true
	#$CollisionShape3D.disabled = false

func OnHitboxEntered(area):
	if area.has_method("GetHit"):
		var effect = null
		
		if appliesEffect and effects.size() > 0:
			effect = effects[0]
			
		area.GetHit(projectile.creator, projectile.damage, effect)
	
	owner.queue_free()
