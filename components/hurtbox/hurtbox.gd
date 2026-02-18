## A reusable hurtbox component that detects incoming hits from HitboxComponents.
##
## Instance this scene as a child of any CharacterBody2D. Set [member entity_type]
## in the inspector to assign the correct physics layer (player or enemy).
## The hurtbox is a passive receiver — it sits on its collision layer with mask 0,
## waiting for hitboxes to detect it. Connect to [signal hit] to respond to damage.
##
## Supports invincibility frames that temporarily disable hit detection after
## taking damage. Connect to [signal invincibility_started] and
## [signal invincibility_ended] for visual feedback (sprite blinking, etc.).
class_name HurtboxComponent
extends Area2D

## Emitted when a HitboxComponent overlaps this hurtbox.
signal hit(hitbox: HitboxComponent, damage: float)

## Emitted when invincibility frames begin.
signal invincibility_started()

## Emitted when invincibility frames end.
signal invincibility_ended()

enum EntityType {
	PLAYER,
	ENEMY
}

## Must match the layer numbers defined in project.godot [layer_names] 2d_physics.
const LAYER_PLAYER_HURTBOX: int = 4
const LAYER_ENEMY_HURTBOX: int = 7

var _is_invincible: bool = false

## Determines which physics layer this hurtbox is assigned to.
@export var entity_type: EntityType = EntityType.PLAYER

## Duration of invincibility frames after being hit. Set to 0.0 to disable.
@export_range(0.0, 5.0, 0.05) var invincibility_duration: float = 1.0

## Toggles hit detection. Syncs with Area2D.monitoring so disabling
## this stops overlap detection immediately.
@export var enabled: bool = true :
	set(value):
		enabled = value
		monitoring = value

@onready var _invincibility_timer: Timer = %InvincibilityTimer


func _ready() -> void:
	_apply_physics_layer()
	_configure_timer()


## Sets collision_layer based on entity_type. Mask is always 0 because
## hurtboxes are passive — hitboxes scan against them, not the reverse.
func _apply_physics_layer() -> void:
	collision_mask = 0
	match entity_type:
		EntityType.PLAYER:
			collision_layer = 1 << (LAYER_PLAYER_HURTBOX - 1)
		EntityType.ENEMY:
			collision_layer = 1 << (LAYER_ENEMY_HURTBOX - 1)


func _configure_timer() -> void:
	_invincibility_timer.one_shot = true
	_invincibility_timer.timeout.connect(_on_invincibility_timer_timeout)


## Called by a HitboxComponent when it detects overlap with this hurtbox.
## Emits the hit signal and starts invincibility frames if configured.
func receive_hit(hitbox: HitboxComponent) -> void:
	if not enabled or _is_invincible:
		return

	hit.emit(hitbox, hitbox.damage)

	if invincibility_duration > 0.0:
		start_invincibility()


## Begins invincibility frames. Disables monitoring so overlapping
## hitboxes won't re-trigger hit when iframes end.
func start_invincibility() -> void:
	if invincibility_duration <= 0.0:
		return

	_is_invincible = true
	monitoring = false
	_invincibility_timer.wait_time = invincibility_duration
	_invincibility_timer.start()
	invincibility_started.emit()


## Cancels invincibility frames early (e.g., on character death).
func end_invincibility() -> void:
	if not _is_invincible:
		return

	_invincibility_timer.stop()
	_finish_invincibility()


## Returns true while invincibility frames are active.
func is_invincible() -> bool:
	return _is_invincible


## Shared cleanup for both timer timeout and manual end_invincibility().
func _finish_invincibility() -> void:
	_is_invincible = false
	if enabled:
		monitoring = true
	invincibility_ended.emit()


func _on_invincibility_timer_timeout() -> void:
	_finish_invincibility()
