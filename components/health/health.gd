class_name HealthComponent
extends Node

signal health_changed(old_value: float, new_value: float)
signal died()
signal health_maxed()

var _current_health: float

@export var max_health: float = 100.0
@export var hurtbox: HurtboxComponent


func _ready() -> void:
	_current_health = max_health
	if hurtbox:
		hurtbox.hit.connect(_on_hurtbox_hit)


func take_damage(damage: float) -> void:
	var old_health: float = _current_health
	_current_health = maxf(_current_health - damage, 0.0)

	if _current_health != old_health:
		health_changed.emit(old_health, _current_health)

	if _current_health <= 0.0:
		died.emit()


func heal(amount: float) -> void:
	var old_health: float = _current_health
	_current_health = minf(_current_health + amount, max_health)

	if _current_health != old_health:
		health_changed.emit(old_health, _current_health)

	if _current_health >= max_health:
		health_maxed.emit()


func get_current_health() -> float:
	return _current_health


func get_health_percent() -> float:
	return _current_health / max_health


func _on_hurtbox_hit(_hitbox: HitboxComponent, damage: float) -> void:
	take_damage(damage)
