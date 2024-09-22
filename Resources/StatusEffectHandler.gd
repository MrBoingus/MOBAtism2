extends Resource
class_name StatusEffectHandler
## Resource definition script.
## This resource is for managing and keeping track of a character's buffs and debuffs.

var user : TestCharacter  ## Character currently utilizing this Status Effect Handler.

func _init() -> void:
	pass

@export var statusEffects : Array[StatusEffect] = [
	
]

func AddStatus():
	pass

func RemoveStatus():
	pass

func GetStatusCount():
	return statusEffects.size()
