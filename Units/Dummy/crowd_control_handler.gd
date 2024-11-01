extends Node
class_name DummyCrowdControlHandler

@onready var dummy : Dummy

var slowed : bool = false
var stunned : bool = false

func _ready() -> void:
	await owner.ready
	dummy = owner

#func _physics_process(delta: float) -> void:
	#if slowed:
		#dummy.speed = dummy.speed * 0.80

func ApplyCrowdControl(duration : float):
	slowed = true
	dummy.speed = (dummy.speed * 0.80)
	
	var newTimer = Timer.new()
	
	newTimer.wait_time = duration
	newTimer.one_shot = true
	newTimer.autostart = true
	
	newTimer.timeout.connect(Timeout)
	
	add_child(newTimer)

func Timeout():
	slowed = false
	dummy.speed = 50
