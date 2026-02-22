## A reusable health component that tracks current and max health.
##
## Instance this scene as a child of any entity that needs health.
## Set [member hurtbox] in the inspector to automatically connect to its
## hit signal — no glue code needed. Connect to [signal health_changed]
## for UI updates and [signal died] for death handling.
class_name HealthComponent
extends Node

## Emitted when health changes. Useful for health bars and damage numbers.
signal health_changed(old_value: float, new_value: float)

## Emitted when health reaches zero.
signal died()

## Emitted when health reaches max_health.
signal health_maxed()

var _current_health: float

## Maximum health value. Also used as the starting health.
@export var max_health: float = 100.0

## Optional reference to a HurtboxComponent. If set, automatically
## connects to its hit signal.
@export var hurtbox: HurtboxComponent


func _ready() -> void:
	_current_health = max_health
	if hurtbox:
		hurtbox.hit.connect(_on_hurtbox_hit)


## Reduces health by the given amount, clamped to zero.
## Only emits health_changed if the value actually changed.
func take_damage(damage: float) -> void:
	var old_health: float = _current_health
	_current_health = maxf(_current_health - damage, 0.0)

	if _current_health != old_health:
		print("Health changed from", old_health, "to", _current_health)  # DEBUG
		health_changed.emit(old_health, _current_health)

	if _current_health <= 0.0:
		died.emit()


## Restores health by the given amount, capped at max_health.
## Only emits health_changed if the value actually changed.
func heal(amount: float) -> void:
	var old_health: float = _current_health
	_current_health = minf(_current_health + amount, max_health)

	if _current_health != old_health:
		health_changed.emit(old_health, _current_health)

	if _current_health >= max_health:
		health_maxed.emit()


## Returns the current health value.
func get_current_health() -> float:
	return _current_health


## Returns health as a ratio from 0.0 to 1.0. Useful for health bar fill.
func get_health_percent() -> float:
	return clampf(_current_health / max_health, 0.0, 1.0)


## Adapts the hurtbox hit signal to take_damage.
func _on_hurtbox_hit(_hitbox: HitboxComponent, damage: float) -> void:
	take_damage(damage)
