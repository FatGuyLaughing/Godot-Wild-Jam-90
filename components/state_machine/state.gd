## Base class for all states. Extend this to create specific states.
##
## The [StateMachine] assigns [member entity] and [member state_machine]
## before the first [method enter] call. Override [method enter], [method exit],
## and [method physics_process] to define state behavior.
## Call [method transition_to] to switch to another state by name.
class_name State
extends Node

## The CharacterBody2D that owns the state machine. Set by StateMachine.
var entity: CharacterBody2D

## Reference to the parent StateMachine. Set by StateMachine.
var state_machine: StateMachine


## Called every physics frame while this state is active.
func physics_process(_delta: float) -> void:
	pass


## Called when transitioning into this state.
func enter() -> void:
	pass


## Called when transitioning out of this state.
func exit() -> void:
	pass


## Convenience method to transition to another state by name.
func transition_to(state_name: String) -> void:
	state_machine.transition_to(state_name)
