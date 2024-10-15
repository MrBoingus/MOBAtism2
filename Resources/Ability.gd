extends Resource
class_name Ability

@export var name: String

@export var abilityType : Enums.abilityType

@export var cooldown: float
#@export var cooldownBase: float
#@export var cooldownCurrent: float
#@export var affectedByCooldownReduction: bool

@export var hitboxes: Array[PackedScene]
@export var projectiles: Array[PackedScene]
