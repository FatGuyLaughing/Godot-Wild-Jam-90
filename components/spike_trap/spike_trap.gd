## A floor trap that triggers when the player walks over it.
##
## Spikes animate up, deal damage via HitboxComponent, then retract
## and reset on a cooldown. Place in any level as an environmental hazard.
class_name SpikeTrap
extends Area2D

## Damage dealt to the player when spikes are active.
@export var damage: float = 10.0

## Time in seconds before the trap can trigger again after retracting.
@export var cooldown_duration: float = 2.0

enum TrapState {
	IDLE,
	ACTIVE,
	COOLDOWN,
}

var _state: TrapState = TrapState.IDLE

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _hitbox: HitboxComponent = %HitboxComponent
@onready var _cooldown_timer: Timer = %CooldownTimer


func _ready() -> void:
	_hitbox.damage = damage
	_hitbox.enabled = false

	_cooldown_timer.one_shot = true
	_cooldown_timer.wait_time = cooldown_duration
	_cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

	body_entered.connect(_on_body_entered)
	_animation_player.animation_finished.connect(_on_animation_finished)


func _on_body_entered(_body: Node2D) -> void:
	if _state != TrapState.IDLE:
		return

	_activate()


func _activate() -> void:
	_state = TrapState.ACTIVE
	_animation_player.play("activate")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"activate":
		return

	_hitbox.enabled = false
	_state = TrapState.COOLDOWN
	_cooldown_timer.start()


func _on_cooldown_timer_timeout() -> void:
	_state = TrapState.IDLE
