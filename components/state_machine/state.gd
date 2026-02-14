class_name State
extends Node

var entity: CharacterBody2D
var state_machine: StateMachine


func physics_process(delta: float) -> void:
	pass


func enter() -> void:
	pass


func exit() -> void:
	pass


func transition_to(state_name: String) -> void:
	state_machine.transition_to(state_name)
