extends Node3D
class_name CameraController
## Camera control node.

@export var pairedUnit: TestCharacter ## The in-game unit this camera is set to follow.

@export_category("Variables")
var rayRange : = 999999
# camera pan
@export_range(0,32,4) var PanMargin : int = 16  ## Determines how close the mouse needs to be to the screen edge in order to pan the screen. A SMALLER margin means the mouse needs to be CLOSER to activate it.
@export_range(0,20,0.5) var PanSpeed : float = 12  ## How fast the camera moves while panning.
# camera speed
@export_range(0,100,1) var moveSpeed: float = 20.0  ## How fast the camera moves while being moved with the keyboard keys.
# camera zoom
var zoomDirection : float = 0.0 ## Float that changes whether or not the camera is zooming in or out, based on input.
@export_range(0,100,1) var zoomSpeed : float = 40.0  ## The speed at which the camera changes zoom level.
@export_range(0,100,1) var zoomMin : float = 10.0  ## The minimum zoom distance.
@export_range(0,100,1) var zoomMax : float = 25.0  ## The maximum zoom distance.
@export_range(0,2,0.1) var zoomSpeedDamp : float = 0.92  ## Basically acts as friction for the camera when zooming, I think. Causes it to slow down gradually.

@export_category("Flags")
@export var canPan : bool = true  ## Whether or not the camera is allowed to pan.
@export var isLocked: bool = false  ## Whether or not the camera is currently locked to its paired unit.
@export var isFollowHeld: bool = false  ## Whether or not the "follow" button is currently being held down.
@export var canProcess : bool = true  ## Whether or not the game should process ANY camera functionality Set this to false to effectively disable any camera movement.
@export var canMoveBase : bool = true  ## Whether or not the camera can be moved with the WASD keys.
@export var canZoom : bool = true  ## Whether or not the camera is allowed to zoom in or out.

# Nodes
@onready var socket: Node3D = $Socket
@onready var camera: Camera3D = %Camera3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !canProcess: return
	
	Camera_Base_Move(delta)
	Camera_Zoom_Update(delta)
	Camera_Pan(delta)

	if pairedUnit and Should_Follow():
		self.position = pairedUnit.position

# This function needs to be moved to a standalone "Player Input" script/class so that we can handle multiple players
func _input(event: InputEvent) -> void:
	# click to move
	if event.is_action_pressed("mouseLeft"):
		Get_Camera_Collision()
	# rightclick to move
	if event.is_action_pressed("mouseRight"):
		Get_Camera_Collision()
		
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
	var panDirection : Vector2 = Vector2(-1,-1) # Starts negative, only changes if it detects other input
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
	

## Creates and casts a raycast from the camera towards the player's mouse. The intersection, if there is one, is then fed to the player unit
## and used for navigation, pathfinding, enemy logic, etc.
func Get_Camera_Collision():
	var mousePosition = get_viewport().get_mouse_position()
	
	var rayOrigin = camera.project_ray_origin(mousePosition)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePosition) * rayRange
	
	var ray = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)

	ray.set_collide_with_areas(true)
	ray.set_collision_mask(2)
	var rayWorld = get_world_3d().direct_space_state.intersect_ray(ray)
	
	if rayWorld:
		print_debug("hit the ground")
		pairedUnit.nav.target_position = rayWorld.position
		pairedUnit.wantsToMove = true
	else:
		print_debug("No intersection")

