extends CharacterBody3D
class_name Minion
## Minion super-class.

@export var alliance : Enums.alliance

@export var type : Enums.minionType

@export var spawnLane : Enums.lane
@export var currentLane : Enums.lane

@export var level : int
@export var experienceValue : int
@export var goldValue : int

@export var health : float
@export var speed : float
@export var damage : float

@onready var mesh : MeshInstance3D = $MeshInstance3D
@onready var hurtbox : MinionHurtbox = $Hurtbox
@export var outlineMaterial : Material

func _ready() -> void:
	currentLane = spawnLane
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	mesh.material_overlay = outlineMaterial

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	mesh.material_overlay = null

func GetHit(attacker:TestCharacter, damageTaken:float, effect:StatusEffect):
	hurtbox.GetHit(attacker, damageTaken, effect)

func Die(killer:TestCharacter):
	queue_free()
	if "experience" in killer and "currentGold" in killer:
		killer.experience += experienceValue
		killer.currentGold += goldValue
