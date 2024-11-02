extends Node
## A Game Master of sorts.

signal CurrentCameraUpdated

var currentCamera : Camera3D

func UpdateCurrentCamera(camera):
	currentCamera = camera
	emit_signal("CurrentCameraUpdated")
