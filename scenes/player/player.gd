## The playable character. Handles attack input and responds to
## health and knockback component signals.
class_name PlayerCharacter
extends CharacterBody2D

## Emitted when the player dies. The level or room manager
## should connect to this to handle game over.
signal died()


@onready var _hurtbox: HurtboxComponent = %HurtboxComponent
@onready var _hitbox: HitboxComponent = %HitboxComponent
@onready var _health: HealthComponent = %HealthComponent
@onready var _state_machine: StateMachine = %StateMachine


func _ready() -> void:
	_hurtbox.hit.connect(_on_hurtbox_hit)
	_health.died.connect(_on_died)
	_hitbox.enabled = false


func _on_died() -> void:
	_state_machine.transition_to("Dead")


func _on_hurtbox_hit(_incoming_hitbox: HitboxComponent, _damage: float) -> void:
	_state_machine.transition_to("Hurt")
