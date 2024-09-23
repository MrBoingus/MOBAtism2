extends Node
class_name Enums
## A list of enumerators that will probably be commonly referenced.

## Which "team" this unit belongs to.
enum alliance {
	LEFT,
	RIGHT,
	NEUTRAL,
	NONE
}

enum rangeType {
	MELEE,
	RANGED
}

enum resourceType {
	MANA,
	ENERGY,
	NONE
}

enum statusEffectType {
	STATUS,
	BUFF,
	DEBUFF,
}
