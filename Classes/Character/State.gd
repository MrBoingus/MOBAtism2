extends Node
class_name State
## Global state class.

# Basic State class.

@onready var player : TestCharacter 
@onready var hurtbox
@onready var stateMachine : StateMachine
#@onready var inputMonitor : InputMonitor
#@onready var attackHandler : AttackHandler
#@onready var grabbox : PlayerGrabBox

#var stateType : Enums.StateTypes
var attackDuration : int

var bufferAttack : bool = false

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	pass
	
func enter():
	pass
	
func exit():
	pass

# Frame Update functions used to keep track of how many frames a character was/has been in a given state.
# I've split them into 3 seperate functions simply for my own readability. 
#
func frame_update_enter():
	pass
	
func frame_update_physics():
	#if player.hitPause:
		#pass
	#else:
	player.stateDuration += 1
	
func frame_update_exit():
	player.stateDuration = 0
