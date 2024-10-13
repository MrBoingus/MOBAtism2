extends Node
class_name TesteeAbilityHandler

@onready var player : TestCharacter

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
	AssignAbilities()

func AssignAbilities():
	currentAbilities[0] = player.abilityArray[0]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ability1"):
		if player.canAttack: player.stateMachine.changeState(currentAbilities[0].name)
