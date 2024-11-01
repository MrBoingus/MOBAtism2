extends CharacterBody3D
class_name Dummy

var health = 550
var lastAttacker
var experienceValue = 50

var speed = 50

@onready var hurtbox: DummyHurtbox = $Hurtbox
@onready var handlers = $Handlers.get_children()
@onready var healthHandler = $Handlers/HealthHandler
@onready var statusEffectHandler: DummyStatusEFfectHandler = $Handlers/StatusEffectHandler
@onready var crowdControlHandler: DummyCrowdControlHandler = $Handlers/CrowdControlHandler


@onready var mesh : MeshInstance3D = $MeshInstance3D
@export var outlineMaterial : Material

func _physics_process(delta: float) -> void:
	pass

func GetHit(attacker:TestCharacter, damage:float, effect:StatusEffect):
	hurtbox.GetHit(attacker, damage, effect)

func _on_status_effect_handler_slowed() -> void:
	print("Dummy has been slowed!")

func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	mesh.material_overlay = outlineMaterial

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	mesh.material_overlay = null
