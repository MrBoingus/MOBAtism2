extends Tower
class_name RightTower

@onready var health : ProgressBar = %Health

@onready var targetArea : Area3D = $TargetArea
@onready var targetAreaCollision : CollisionShape3D = $TargetArea/CollisionShape3D


func _ready() -> void:
	super()
	
	targetAreaCollision.shape.radius = baseAttackRange
	
	targetArea.body_entered.connect(BodyEnteredAttackArea)
	targetArea.body_exited.connect(BodyExitedAttackArea)

func BodyEnteredAttackArea(body : Node3D):
	if "alliance" in body:
		# If valid TARGET
		if body.alliance in validTargets:
			print("enemy has entered my targeting range")
			if target == null:
				target = body
			else:
				nearbyTargets.append(body)
		# If TEAMMATE
		elif body.alliance == team:
			nearbyCharacters.append(body)

func BodyExitedAttackArea(body : Node3D):
	if "alliance" in body:
		# If valid TARGET
		if validTargets.has(body.alliance):
			print("enemy has exited my targeting range")
			if nearbyTargets.is_empty():
				target = null
			else:
				target = nearbyTargets[0]
				nearbyTargets.erase(body)
		# If TEAMMATE
		elif body.alliance == team:
			nearbyCharacters.erase(body)
