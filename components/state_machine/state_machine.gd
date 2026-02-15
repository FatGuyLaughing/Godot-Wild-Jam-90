## A reusable state machine that manages child State nodes.
##
## Add State nodes as children and set [member starting_state] in the inspector.
## The state machine registers all child states by name, assigns them the owner
## entity, and delegates _physics_process to the active state.
## Call [method transition_to] with a state name to switch states.
class_name StateMachine
extends Node

var _current_state: State
var _states: Dictionary

## The state to enter when the scene is ready.
@export var starting_state: State


func _ready() -> void:
	# Wait for the owner (e.g., PlayerCharacter) to be ready so states
	# can safely access sibling nodes via %UniqueNames.
	await owner.ready
	for child: State in get_children():
		_states[child.name] = child
		child.entity = owner
		child.state_machine = self

	_current_state = starting_state
	starting_state.enter()


func _physics_process(delta: float) -> void:
	_current_state.physics_process(delta)


## Exits the current state and enters the named state.
func transition_to(state_name: String) -> void:
	if _states.has(state_name):
		_current_state.exit()
		_current_state = _states[state_name]
		_current_state.enter()
