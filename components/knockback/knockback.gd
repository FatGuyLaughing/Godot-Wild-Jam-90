## A reusable knockback component that calculates and emits knockback velocity.
##
## Instance this scene as a child of any entity that can be knocked back.
## Set [member hurtbox] in the inspector to automatically connect to its
## hit signal. The movement component should connect to [signal knockback_applied]
## to blend the knockback velocity with movement input.
class_name KnockbackComponent
extends Node

## Emitted when knockback is triggered. The movement component should
## connect to this and apply the velocity.
signal knockback_applied(velocity: Vector2)

## Optional reference to a HurtboxComponent. If set, automatically
## connects to its hit signal.
@export var hurtbox: HurtboxComponent

## The force of the knockback impulse.
@export var knockback_strength: float = 200.0


func _ready() -> void:
	if hurtbox:
		hurtbox.hit.connect(_on_hurtbox_hit)


## Calculates knockback direction from the hitbox's position and emits
## the resulting velocity.
func _on_hurtbox_hit(hitbox: HitboxComponent, _damage: float) -> void:
	var direction: Vector2 = _calculate_knockback_direction(hitbox)
	knockback_applied.emit(direction * knockback_strength)


## Returns a normalized direction vector pointing away from the hitbox.
## Defaults to Vector2.RIGHT if the hitbox is exactly overlapping.
func _calculate_knockback_direction(hitbox: HitboxComponent) -> Vector2:
	var direction: Vector2 = hitbox.global_position.direction_to(owner.global_position)
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT

	return direction
