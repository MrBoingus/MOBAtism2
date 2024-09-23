extends Node
class_name TesteeAttackHandler

@onready var player : TestCharacter

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attackMove"):
		pass
