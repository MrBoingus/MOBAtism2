extends Node3D

@onready var characterUI: Sprite3D = $"Character UI"
var camera : Camera3D

func _ready() -> void:
	await Overseer.CurrentCameraUpdated
	camera = Overseer.currentCamera

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("cameraRight"):
		print(global_rotation)
	
	global_rotation.y = -0
	global_rotation.z = 0
	
	#if Overseer.currentCamera.unproject_position(global_position).y > get_viewport().size.y / 2:
		#look_at(camera.global_position)
		#print(rad_to_deg(rotation.x))
	#else:
		#rotation = Vector3.ZERO
