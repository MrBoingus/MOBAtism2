extends Character
class_name TestCharacter
## The current default test character. For testing purposes. His name will be Testee.
## The front of this character is the negative Z-axis.

#region Variables
var alliance = Enums.alliance.LEFT

var speed : int = 350  ## Default movement speed value.

var target

var stateDuration
var previousState
var currentState

# Movement/Navigation
var direction = Vector3()  ## Used during movement calculation to determine what direction the player should move in.
var nextPosition = Vector3()  ## The next navigation path position will be stored here.
@export var wantsToMove : bool = false  ## Whether or not this character is currently attempting to move to another location.
@export var canMove : bool = true
@export var canAttack : bool = true

# Flags
var searching : bool

var node
func DeleteNode():
	if node: node.queue_free()

#endregion

#region Nodes
@onready var nav: NavigationAgent3D = $NavigationAgent3D  ## This characters NavigationAgent node.
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var attackHandler: TesteeAttackHandler = %AttackHandler
@onready var statusEffectHandler: TesteeStatusEffectHandler = %StatusEffectHandler
@onready var abilityHandler: TesteeAbilityHandler = %AbilityHandler
@onready var stateMachine: TesteeStateMachine = %StateMachine
@onready var levelUI: Label = %Level

@onready var spellBar: HBoxContainer = %"Spell Bar"
@onready var abilityTimer1 : Label = %Label1

@onready var healthBar : ProgressBar = %Health
@onready var manaBar : ProgressBar = %Mana

@onready var center: Marker3D = $Center


#endregion

#region Resources
@export var baseStats : CharacterBaseStats
@export var stats : CharacterStatContainer
@export var abilityArray : Array[Ability]

#endregion

func _ready() -> void:
	ConnectNavSignals()
	ApplyStats()

## Connect outside signals to custom signals. Called in the ready function.
func ConnectNavSignals():
	nav.path_changed.connect(PathChanged)
	nav.navigation_finished.connect(NavigationFinished)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("stop"):
		searching = false
		wantsToMove = false
		nav.target_position = global_position

func _physics_process(delta: float) -> void:
	# IMPORTANT: "GET_NEXT_PATH_POSITION" IS INTEGRAL TO NAVIGATION.
	# The navigation path wont be loaded until it is called at least once,
	# AND Godot says it should be called every frame to keep it updated.
	nextPosition = nav.get_next_path_position()
	
	NavigationLogic(delta)

#region Custom Functions

func GetHit(damage):
	stats.health -= damage
	healthBar.value = stats.health
	
	if stats.health <= 0:
		queue_free()
		#lastAttacker.target = null
		#dummy.lastAttacker.ReceiveExperience(dummy.experienceValue)

## Basic Navigation and Movement logic meant to run every physics frame.
# TODO Tre mentioned this in the last project but Godot only allows for 0.1m precision in navigation, for some reason. Code our own LATER?
func NavigationLogic(delta : float):
	# Check for enemies around you
	if searching: SearchForEnemy()
	
	if target: FollowTarget()
	else: animation.play("Idle")
	
	if wantsToMove and canMove:
		
		# Determine next position, its direction relative to us, and move towards it.
		direction = global_position.direction_to(nextPosition)
		velocity = direction * delta * speed
		move_and_slide()
		# Make character look at the next position, if we arent at the final position.
		if nextPosition == nav.target_position:
			pass
		else:
			var offset = nextPosition - global_position
			offset.y = 0
			if not offset.is_zero_approx():
				look_at(global_position + offset, Vector3.UP)

## When called, this is meant to initialize the character's CURRENT stats from their BASE stats.
func ApplyStats():
	stats.requiredExperience = baseStats.experiencePerLevel
	
	stats.movementSpeed = baseStats.baseMovementSpeed
	
	stats.maxHealth = baseStats.baseMaxHealth
	stats.health = baseStats.baseMaxHealth
	stats.healthRegen = baseStats.baseHealthRegen
	
	stats.maxResource = baseStats.baseMaxResource
	stats.resource = baseStats.baseMaxResource
	stats.resourceRegen = baseStats.baseResourceRegen
	
	stats.physicalReduction = baseStats.basePhysicalReduction
	stats.magicReduction = baseStats.baseMagicReduction
	stats.reduction = baseStats.baseReduction
	
	stats.attackRange = baseStats.baseAttackRange
	stats.attackSpeed = baseStats.baseAttackSpeed

#endregion

# NOTE: Right now, this also serves to check if the enemy is in-range to attack.
# if we make the characters attack search range different from their attack range,
# this will change.
func SearchForEnemy():
	var enemyLayer = 2
	
	var shapeCast = ShapeCast3D.new()
	var newShape = SphereShape3D.new()
	newShape.radius = baseStats.baseAttackRange
	shapeCast.shape = newShape
	
	add_child(shapeCast)
	
	shapeCast.set_collision_mask(pow(2, enemyLayer - 1))
	shapeCast.force_shapecast_update()
	
	if shapeCast.collision_result:
		var enemy = shapeCast.collision_result[0]
		
		#nav.target_position = enemy.collider.global_position
		
		target = enemy.collider
		wantsToMove = true
		searching = false
		
		shapeCast.queue_free()

func FollowTarget():
	if !target: return
	
	if global_position.distance_to(target.global_position) > baseStats.baseAttackRange:
		nav.target_position = target.global_position
		wantsToMove = true
	else:
		wantsToMove = false
		#nav.target_position = target.global_position
		look_at(target.global_position)
		rotation.x = 0
		rotation.z = 0
		if attackHandler.attackTimer.time_left > 0.0:
			pass
		else:
			animation.play("BasicAttack")

func ReceiveExperience(value):
	if stats.experience + value >= stats.requiredExperience:
		IncreaseLevel()
	else:
		print("got xp but didnt level up")
		stats.experience += value

func IncreaseLevel():
	if stats.currentLevel + 1 > baseStats.maxLevel:
		pass
	else:
		stats.experience = 0
		stats.currentLevel += 1
		levelUI.text = str(stats.currentLevel)
		print_debug("leveled up!")

#region Connections To External Functions
# NOTE: It seems that when avoidance is enabled, velocity_computed is constantly emitted,
# EVEN WITHOUT A PATH BEING LOADED.

func PathChanged():
	print("path changed called")
	#nav.get_next_path_position()

#func WaypointReached():

func NavigationFinished():
	print("navigation finished")
	wantsToMove = false

#endregion
