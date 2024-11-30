extends Node3D
class_name Main



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		print(%CharacterBody3D.nav.target_position - %CharacterBody3D.global_position)
		#print($CharacterBody3D.nav.get_current_navigation_path())
		#print($CharacterBody3D.nav.target_position)
