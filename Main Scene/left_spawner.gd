extends Node3D

@onready var label: Label = $Sprite3D/SubViewport/Label
@onready var timer : Timer

func _process(delta: float) -> void:
	label.text = str(snapped(timer.time_left, 0.1))
