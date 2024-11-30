extends Node
class_name Tower

@export_group("Team")
@export var team : Enums.alliance

@export_group("Targeting")
@export var validTargets : Array[Enums.alliance]
@export var target : Character
@export var nearbyTargets : Array

@export_group("Players")
@export var nearbyCharacters : Array[Character] = []

@export_group("Base Stats")
@export var baseHealth : float = 1000
@export var baseAttackRange : float = 5
@export var baseAttackDamage : float = 100
@export var baseRampLevel : int = 0
@export var baseLevel : int = 1

@export_group("Current Stats")
@export var currentHealth : float
@export var currentAttackRange : float
@export var currentAttackDamage: float
@export var currentRampLevel : int
@export var currentLevel : int

func _ready() -> void:
	currentHealth = baseHealth
	currentAttackRange = baseAttackRange
	currentAttackDamage = baseAttackDamage
	currentRampLevel = baseRampLevel
	currentLevel = baseLevel
