class_name StateMachine
extends Node

var _current_state: State
var _states: Dictionary

@export var starting_state: State


func _ready() -> void:
	await owner.ready
	for child: State in get_children():
		_states[child.name] = child
		child.entity = owner
		child.state_machine = self
	
	_current_state = starting_state
	starting_state.enter()


func _physics_process(delta: float) -> void:
	_current_state.physics_process(delta)


func transition_to(state_name: String) -> void:
	if _states.has(state_name):
		_current_state.exit()
		_current_state = _states[state_name]
		_current_state.enter()
