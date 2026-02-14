## A reusable movement component that applies directional velocity to a CharacterBody2D.
##
## States call [method apply_movement] with a direction vector each physics frame.
## Set [member knockback] in the inspector to automatically blend knockback
## impulses into movement. Knockback decays over time back to zero.
class_name MovementComponent
extends Node

var _knockback_velocity: Vector2 = Vector2.ZERO

## Movement speed in pixels per second.
@export var move_speed: float = 5.0

## Optional reference to a KnockbackComponent. If set, automatically
## connects to its knockback_applied signal.
@export var knockback: KnockbackComponent


func _ready() -> void:
	if knockback:
		knockback.knockback_applied.connect(_on_knockback_applied)


## Applies movement to the character, blending directional input with
## any active knockback. Call this from a state's physics_process.
func apply_movement(character: CharacterBody2D, direction: Vector2) -> void:
	character.velocity = (direction * move_speed) + _knockback_velocity
	character.move_and_slide()
	# Decay knockback each frame so it naturally fades out
	_knockback_velocity = _knockback_velocity.move_toward(Vector2.ZERO, move_speed)


## Receives a knockback impulse from the KnockbackComponent.
func _on_knockback_applied(velocity: Vector2) -> void:
	_knockback_velocity = velocity
