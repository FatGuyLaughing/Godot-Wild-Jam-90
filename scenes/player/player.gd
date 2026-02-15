## The playable character. Wires up combat components and handles
## global state transitions (hurt, death) that can occur in any state.
## Individual states handle input, movement, and animations.
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


## Forces transition to Dead state and emits died signal.
func _on_died() -> void:
	_state_machine.transition_to("Dead")
	died.emit()


## Forces transition to Hurt state from any active state.
func _on_hurtbox_hit(_incoming_hitbox: HitboxComponent, _damage: float) -> void:
	_state_machine.transition_to("Hurt")
