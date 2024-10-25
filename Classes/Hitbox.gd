extends Area3D
class_name Hitbox

@onready var projectile

func _ready() -> void:
	await owner.ready
	projectile = owner
	
	area_entered.connect(OnHitboxEntered)

func OnHitboxEntered(area : DummyHurtbox):
	# for testing
	var node = MeshInstance3D.new()
	var mesh = SphereMesh.new()
	
	mesh.radius = 0.7
	mesh.height = 1.4
	
	node.mesh = mesh
	node.global_position = projectile.global_position
	
	projectile.creator.DeleteNode()
	projectile.creator.node = node
	get_tree().root.add_child(node)
	#
	
	area.GetHit(projectile.creator, projectile.damage)
	owner.queue_free()
