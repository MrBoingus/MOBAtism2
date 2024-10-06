extends StateMachine
class_name TesteeStateMachine

signal changedState

@export var INITIAL_STATE : NodePath
@onready var state = get_node(INITIAL_STATE)
@onready var player : Character

func _ready() -> void:
	await owner.ready
	assert(owner != null)
	player = owner
	
	for child in get_children():
		if !"stateMachine" in child:
			print_debug("Some children don't have stateMachine variables!")
		else:
			child.stateMachine = self
	state.enter()
	
func _unhandled_input(event: InputEvent):
	state.handle_input(event)
	
func _update(delta):
	state.update(delta)
	
func _physics_process(delta: float) -> void:
	state.physics_update(delta)

# Custom Function(s)

func changeState(newState: String):
	if !has_node(newState):
		print_debug("Tried to switch to an invalid state!")
		return
	
	state.exit()
	state.frame_update_exit()
	player.previousState = state
	
	state = get_node(newState)
	player.currentState = state
	
	state.enter()
	state.frame_update_enter()
	
	print_debug(newState)
	emit_signal("changedState")
	#print(Engine.get_physics_frames())
	
	if !player.animation.has_animation(newState):
		print_debug("no animation exists for state '" + newState + "'")
	else:
#		if "sprites" in player:
#			if !player.sprites.has(new_state):
#				pass
#				print_debug("character lacks sprite resource for state '" + new_state + "'")
#			else:
#				player.sprite.texture = player.sprites[new_state]
			player.animation.play("RESET")
			player.animation.advance(0)
			player.animation.play(newState)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == state.name:
		if state.has_method("AnimationFinished"):
			state.AnimationFinished()
