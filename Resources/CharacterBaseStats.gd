extends Resource
class_name CharacterBaseStats
## Resource definition script.
## This resource contains all of a CHARACTER'S *BASE* stats.
## Normally, these should NOT be altered during gameplay!!

@export var nickname : String  ## INTERNAL name of the character. NOT TO BE DISPLAYED TO ANY USERS OR PLAYERS.
@export var characterIndex : int  ## Order in the roster. The test character, Testee, is 0.
@export var ranged : bool  ## Whether this character is ranged or melee.
@export var baseMovementSpeed : int  ## Default movement speed at level 1 without modifiers.

@export_group("Level")
@export var maxLevel : int = 18  ## Maximum possible level. Keeping it at 18 for all characters for now.
## Amount of experience they need to level up from level 1 to level 2. Will also be universal.
## For subsequent levels I will multiply this by a multiplier that increases with each level.
@export var experiencePerLevel : int

@export_group("Health")
@export var baseMaxHealth : float  ## Maximum health value this character starts the game with before any modifiers.
@export var healthGrowth : float  ## Amount added to this characters maximum health every time they level up.
@export var baseHealthRegen : float  ## Health this character recovers every half-second at level 1 without any modifiers.
@export var healthRegenGrowth : float  ## Amount added to this characters health regeneration every time they level up.

@export_group("Secondary Resource")
@export var resource : Enums.resourceType  ## Secondary resource this character uses.
@export var baseMaxResource : float  ## Maximum amount of their secondary resource they can store, if they have one.
@export var resourceGrowth : float  ## Amount added to this characters maximum stored resource every time they level up.
@export var baseResourceRegen : float  ## Resource this character recovers every half-second at level 1 without any modifiers.
@export var resourceRegenGrowth : float  ## Amount added to this characters resource regeneration every time they level up.

@export_group("Defense")
@export var basePhysicalReduction : int  ## This would be equivalent to Armor in League. Most characters will not start with any resistances. 
@export var baseMagicReduction : int  ## This would be equivalent to Magic Reist in League. Most characters will not start with any resistances.
@export var baseReduction : int  ## This would be equivalent to pure Damage Reduction. Most characters will not start with any resistances.

@export_group("Basic Attack")
@export var baseAttackRange : int  ## This character's default attack range, the range at which they can attack other units.

@export var baseAttackDamage : int  ## Attack Damage value with no modifiers at level 1.
@export var attackDamageGrowth : int  ## Amount added to this characters base Attack Damage every time they level up.

@export var baseAttackSpeed : float  ## How frequently this character can Basic Attack without modifiers at level 1.
@export var attackSpeedGrowth : float  ## Amount added to this characters base Attack Speed every time they level up.

func PrintSomething(input):
	print(input)
