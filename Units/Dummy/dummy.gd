extends CharacterBody3D
class_name Dummy

@onready var mesh : MeshInstance3D = $MeshInstance3D
@export var outlineMaterial : Material

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

func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	mesh.material_overlay = outlineMaterial
	

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	mesh.material_overlay = null
	
