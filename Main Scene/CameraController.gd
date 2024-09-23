extends Node3D
class_name CameraController
## Camera control node.

@export var pairedUnit: TestCharacter ## The in-game unit this camera is set to follow.
@onready var attackArea: CollisionShape3D = $AttackArea/CollisionShape3D


@export_category("Variables")
var rayRange : = 999999
# camera pan
## Determines how close the mouse needs to be to the screen edge in order to pan the screen.
## A SMALLER margin means the mouse needs to be CLOSER to activate it.
@export_range(0,32,4) var PanMargin : int = 16
## How fast the camera moves while panning.
@export_range(0,20,0.5) var PanSpeed : float = 12
# camera speed
## How fast the camera moves while being moved with the keyboard keys.
@export_range(0,100,1) var moveSpeed: float = 20.0
# camera zoom
## Float that changes whether or not the camera is zooming in or out, based on input.
var zoomDirection : float = 0.0
## The speed at which the camera changes zoom level.
@export_range(0,100,1) var zoomSpeed : float = 40.0
@export_range(0,100,1) var zoomMin : float = 10.0  ## The minimum zoom distance.
@export_range(0,100,1) var zoomMax : float = 25.0  ## The maximum zoom distance.
## Basically acts as friction for the camera when zooming, I think. Causes it to slow down gradually.
@export_range(0,2,0.1) var zoomSpeedDamp : float = 0.92

@export_category("Flags")
## Whether or not the camera is allowed to pan.
@export var canPan : bool = true
## Whether or not the camera is currently locked to its paired unit.
@export var isLocked: bool = false
## Whether or not the "follow" button is currently being held down.
@export var isFollowHeld: bool = false
## Whether or not the game should process ANY camera functionality
## Set this to false to effectively disable any camera movement.
@export var canProcess : bool = true
@export var canMoveBase : bool = true  ## Whether or not the camera can be moved with the WASD keys.
@export var canZoom : bool = true  ## Whether or not the camera is allowed to zoom in or out.

# Nodes
@onready var socket: Node3D = $Socket
@onready var camera: Camera3D = %Camera3D

func _ready() -> void:
	$AttackArea/CollisionShape3D.shape.radius = pairedUnit.baseStats.baseAttackRange

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !canProcess: return
	
	#Camera_Base_Move(delta)
	Camera_Zoom_Update(delta)
	Camera_Pan(delta)

	if pairedUnit and Should_Follow():
		self.position = pairedUnit.position

# This function needs to be moved to a standalone "Player Input" script/class so that we can
# handle multiple players
func _input(event: InputEvent) -> void:
	# click to move
	if event.is_action_pressed("mouseLeft"):
		GetCameraCollision()
	# rightclick to move
	if event.is_action_pressed("mouseRight"):
		GetCameraCollision()
		
	if event.is_action_pressed("attackMove"):
		GetAttackCollision()
		
	# camera Lock
	if event.is_action_pressed("cameraLock"):
		isLocked = not isLocked
		
	# camera Follow
	if event.is_action_pressed("cameraFollow"):
		isFollowHeld = true
	if event.is_action_released("cameraFollow"):
		isFollowHeld = false
		
	# camera Zoom
	if event.is_action("cameraZoomIn"):
		zoomDirection = -1
	elif event.is_action("cameraZoomOut"):
		zoomDirection = 1

## Determines whether or not the player should be followed by the camera.
func Should_Follow() -> bool:
	if (isLocked or isFollowHeld):
		return true
	else:
		return false

## Calculates camera movement and moves camera based on input from the WASD keys.
func Camera_Base_Move(delta : float) -> void:
	if !canMoveBase: return
	var velocityDirection : Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("cameraForward"): velocityDirection -= transform.basis.z
	if Input.is_action_pressed("cameraBackward"): velocityDirection += transform.basis.z
	if Input.is_action_pressed("cameraRight"): velocityDirection += transform.basis.x
	if Input.is_action_pressed("cameraLeft"): velocityDirection -= transform.basis.x
	
	position += velocityDirection.normalized() * moveSpeed * delta

## Changes the camera's zoom level based on input.
func Camera_Zoom_Update(delta : float) -> void:
	if !canZoom: return
	
	var newZoom : float = camera.position.z + zoomSpeed * zoomDirection * delta
	camera.position.z =clampf(newZoom, zoomMin, zoomMax)
	zoomDirection *= zoomSpeedDamp

## Pans the camera in a direction based on the location of the mouse in the viewport.
func Camera_Pan(delta : float) -> void:
	if !canPan: return
	
	var viewportCurrent : Viewport = get_viewport()
	# vv Starts negative, only changes if it detects other input vv
	var panDirection : Vector2 = Vector2(-1,-1)
	var viewportRectangle : Rect2i = Rect2i(viewportCurrent.get_visible_rect())
	var viewportSize : Vector2i = viewportRectangle.size
	var mousePosition : Vector2 = viewportCurrent.get_mouse_position()
	
	var zoomFactor : float = camera.position.z * 0.1
	
	# X Panning
	if ( (mousePosition.x < PanMargin) or (mousePosition.x > viewportSize.x - PanMargin) ):
		if mousePosition.x > viewportSize.x/2:
			panDirection.x = 1
		translate( Vector3(panDirection.x * delta * PanSpeed * zoomFactor, 0, 0) )
	
	# Y Panning
	if ( (mousePosition.y < PanMargin) or (mousePosition.y > viewportSize.y - PanMargin) ):
		if mousePosition.y > viewportSize.y/2:
			panDirection.y = 1
		translate( Vector3( 0, 0, panDirection.y * delta * PanSpeed * zoomFactor) )
	

## Creates and casts a raycast from the camera towards the player's mouse. The intersection,
## if there is one, is then fed to the player unit and used for navigation,
## pathfinding, enemy logic, etc.
func GetCameraCollision():
	var mousePosition = get_viewport().get_mouse_position()
	
	var rayOrigin = camera.project_ray_origin(mousePosition)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePosition) * rayRange
	var ray = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)

	ray.set_collide_with_areas(true)
	var layer = 4
	ray.set_collision_mask(pow(2, layer - 1))
	var rayWorld = get_world_3d().direct_space_state.intersect_ray(ray)
	
	if rayWorld:
		print_debug("hit the ground")
		pairedUnit.nav.target_position = rayWorld.position
		pairedUnit.wantsToMove = true
	else:
		print_debug("No intersection")

func GetAttackCollision():
	var mousePosition = get_viewport().get_mouse_position()
	
	var rayOrigin = camera.project_ray_origin(mousePosition)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePosition) * rayRange
	var ray = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)

	ray.set_collide_with_areas(true)
	var layer = 4
	ray.set_collision_mask(pow(2, layer - 1))
	var rayWorld = get_world_3d().direct_space_state.intersect_ray(ray)
	
	layer = 2
	ray.set_collision_mask(pow(2, layer - 1))
	var rayAttack = get_world_3d().direct_space_state.intersect_ray(ray)
	
	if rayAttack:
		print_debug("directly hit an enemy, " + rayAttack.collider.name)
		pairedUnit.nav.target_position = rayAttack.collider.global_position
		pairedUnit.wantsToMove = true
	else:
		attackArea.global_position = rayWorld.position # For debugging
		
		# Define the attack area
		var shapeCast = ShapeCast3D.new()
		var newShape = SphereShape3D.new()
		newShape.radius = pairedUnit.baseStats.baseAttackRange
		shapeCast.shape = newShape
		
		# Instantiate the attack area
		add_child(shapeCast)
		shapeCast.global_position = rayWorld.position
		
		# Update the attack area to detect collisions
		shapeCast.set_collision_mask(layer)
		shapeCast.force_shapecast_update()
		var enemy
		# vv Returns data about NEAREST area vv
		if shapeCast.collision_result: enemy = shapeCast.collision_result[0]
		
		shapeCast.queue_free()
		
		# Handle collisions, if any.
		if enemy:
			print("found enemy through area")
			pairedUnit.nav.target_position = enemy.collider.global_position
			pairedUnit.wantsToMove = true
		else:
			print("didn't hit any enemies")
