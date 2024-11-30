extends Node

## I will probably have this node tell all minions in a wave
## what their current target location is. Additionally 
## I will probably also have a "wave follower" that 
## Moves directly down the center of a lane path. It will track
## The location of one of the minions and only move forward
## If that minion does. If any minion leaves a certain area around
## the lane follower, they will be forced back into it. The lane follower
## will be the one who searches for valid targets and commands any
## minions in range to attack them.
# Note: have champions emit a "call for help" signal when attacked
# by an enemy, which nearby minions and towers will tune into for aggro.
# I think for this we will have the lane follower check an area around
# the champion being hit and see which minions are close enough to aggro.
# It will then assign that champion as the target of any nearby minions.

signal WavesSpawned

@onready var currentWave
@onready var waveMinionCount : int
@onready var minionList : Array

@onready var minion = preload("res://Classes/Minions/meleeMinion.tscn")

@onready var timer: Timer = $Timer
@onready var leftSpawner: Node3D = $"Left Spawner"
@onready var rightSpawner: Node3D = $RightSpawner

var spawners : Array
var defaultWave : Array

func _ready() -> void:
	# Should automate this later.
	spawners.append(leftSpawner)
	spawners.append(rightSpawner)
	
	leftSpawner.timer = timer
	
	defaultWave.resize(3)
	for m in defaultWave:
		m = minion.instantiate()

func _on_timer_timeout() -> void:
	# Need to clean up and automate this code somehow.
	for s in spawners:
		var newMinion1 = minion.instantiate()
		var newMinion2 = minion.instantiate()
		var newMinion3 = minion.instantiate()
		
		add_child(newMinion1)
		add_child(newMinion2)
		add_child(newMinion3)
		
		newMinion1.global_position = s.global_position
		
		newMinion2.global_position = s.global_position
		newMinion2.global_position.z -= 2.5
		
		newMinion3.global_position = s.global_position
		newMinion3.global_position.z += 2.5
		
	#waveMinionCount += 3
	emit_signal("WavesSpawned")
