extends State
class_name StateConnector

# All player states inherit from this node.
# Just here for some boilerplate and setup.

func _ready() -> void:
	await owner.ready
	assert(owner != null)
	player = owner as Character
