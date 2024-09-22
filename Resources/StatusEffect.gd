extends Resource
class_name StatusEffect
## Resource definition script.
## This resource is meant to represent individual status effects (buffs, debuffs, or otherwise).

var statusHandler : StatusEffectHandler  ## The Status Handler this Status Effect is currently being managed by.

## Function to be called when this Status Effect is added to a Status Handler.
func AddToEffectHandler( handler : StatusEffectHandler):
	if handler: statusHandler = handler

@export var statusName : String  ## Name of the status to be displayed in-game.
@export var statusType : Enums.statusEffectType ## Whether this is a BUFF, DEBUFF or neutral STATUS.


