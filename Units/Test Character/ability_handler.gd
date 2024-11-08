extends Node
class_name TesteeAbilityHandler

@onready var player : TestCharacter
@onready var timers
@onready var basicAbilityTimer_1: Timer = $BasicAbility1

## The actual abilities currently available on the Ability Bar.
## Will change for multiple reasons such as: leveling up or
## using an ability that has a recast or follow up.
## Slots 0 - 4 of the array will always correspond to the same ability, as such:
## 0:passive, 1:Q, 2:W, 3:E, 4:R
@export var currentAbilities : Array[Ability]

func _ready() -> void:
	await owner.ready
	player = owner
	
	currentAbilities.resize(5)
	timers = get_children()
	AssignAbilities()

func _process(delta: float) -> void:
	if basicAbilityTimer_1.time_left > 0:
		player.abilityTimer1.text = str(snapped(basicAbilityTimer_1.time_left, 0.1))

func AssignAbilities():
	var index = 0
	
	for a in player.abilityArray:
		currentAbilities[index] = player.abilityArray[index]
		timers[index].wait_time = player.abilityArray[index].cooldown
		
		index += 1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ability1"):
		if timers[1].is_stopped() and player.canAttack:
			player.stateMachine.changeState(currentAbilities[1].name)
