extends Node
#class_name Enum
## A list of enumerators that will probably be commonly referenced.

# Overall game stuff

## For minions.
## The lane they were assigned to when they were spawned.
enum lane {
	TOP,
	MIDDLE,
	BOTTOM,
}

## Which "team" a unit belongs to.
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

enum crowdControlType {
	SLOW,
	STUN,
	KNOCKUP,
}

enum abilityType {
	TARGET,
	PROJECTILE,
	AREA,
}

# Minions

enum minionType {
	MELEE,
	RANGED,
	CANNON,
}
