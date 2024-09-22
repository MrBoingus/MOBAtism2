extends Resource
class_name CharacterStatContainer
## Resource definition script.
## This resources keeps track of a character's current stats as they are updated during gameplay.

@export_group("Level")
@export var currentLevel : int  ## Current character level.
@export var experience : int  ## Current amount of experience.
@export var requiredExperience : int  ## Experience required to level up.

@export_group("Movement")
@export var movementSpeed : int  ## Current movement speed.

@export_group("Health")
@export var health : int  ## Current health value.
@export var maxHealth : float  ## Current maximum health value.
@export var healthRegen : float  ## Current health regen per half second.

@export_group("Secondary Resource")
@export var resource : float  ## Current resource value.
@export var maxResource : float  ## Current maximum amount of secondary resource.
@export var resourceRegen : float  ## Current maximum resource regen per half second.

@export_group("Defense")
@export var physicalReduction : int  ## Current percentage reduction to incoming physical damage. 
@export var magicReduction : int  ## Current percentage reduction to incoming magic damage. 
@export var reduction : int  ## Current percentage reduction to ALL types of incoming damage. 

@export_group("Basic Attack")
@export var attackRange : int  ## Current attack range.

@export var attackSpeed : float  ## Current attack damage.
