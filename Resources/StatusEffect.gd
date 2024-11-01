extends Resource
class_name StatusEffect
## Resource definition script.
## This resource is meant to represent individual status effects
## (buffs, debuffs, or otherwise).

## The character that created or applied this status effect.
var source : Character

## Is this effect visible on the status bar?
@export var visible : bool
## If visible, does this effect display
## on the left side of the status bar?
@export var leftDisplay : bool

# The Status Handler this Status Effect is currently being managed by.
#var statusHandler : StatusEffectHandler

# Function to be called when this Status Effect is added to a
# Status Handler.
#func AddToEffectHandler( handler : StatusEffectHandler):
	#if handler: statusHandler = handler

func Run(target):
	pass

## Name of the status to be displayed in-game.
@export var statusName : String
## Whether this is a BUFF, DEBUFF or neutral STATUS.
@export var statusType : Enums.statusEffectType
## How long does this effect last?
@export var duration : float

## If this effect is a debuff, is it crowd control?
@export var crowdControl : bool
## If this effect is crowd control, what kind?
@export var crowdControlType : Enums.crowdControlType
