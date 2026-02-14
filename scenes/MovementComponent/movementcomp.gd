class_name MovementComponent extends Node

@export var move_speed: float = 5.0

func _apply_movement(character: CharacterBody2D, direction: Vector2) -> void:
	character.velocity = direction * move_speed
	
