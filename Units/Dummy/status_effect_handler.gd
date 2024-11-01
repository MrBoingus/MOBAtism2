extends Node
class_name DummyStatusEFfectHandler

signal Slowed
signal Stunned

var slowed : bool = false
var stunned : bool = false
#var knockedUp : bool = false

var effects : Array[StatusEffect]
var buffs = []
var debuffs = []
var neutrals = []

func AddStatusEffect(effect : StatusEffect):
	if effect.crowdControl:
		match effect.crowdControlType:
			Enums.crowdControlType.SLOW:
				slowed = true
			Enums.crowdControlType.STUN:
				stunned = true
				
		CreateEffectTimer(effect.duration, effect.crowdControlType)
		EmitCrowdControlSignal(effect.crowdControlType)
	
	match effect.statusType:
		Enums.statusEffectType.BUFF:
			buffs.append(effect)
		Enums.statusEffectType.DEBUFF:
			debuffs.append(effect)
		Enums.statusEffectType.STATUS:
			neutrals.append(effect)
	
	effects.append(effect)

func RemoveStatusEffect():
	pass

func CreateEffectTimer(time:float, crowdControlType):
	var newTimer = Timer.new()
	
	newTimer.wait_time = time
	
	newTimer.one_shot = true
	newTimer.autostart = true
	
	newTimer.timeout.connect(EffectTimerTimeout)
	
	add_child(newTimer)

func EffectTimerTimeout():
	slowed = false
	print("Crowd control over")

func EmitCrowdControlSignal(type):
	match type:
		Enums.crowdControlType.SLOW:
			emit_signal("Slowed")
		Enums.crowdControlType.STUN:
			emit_signal("Stunned")
