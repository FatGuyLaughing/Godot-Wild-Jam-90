## The playable character. Wires up combat components and handles
## global state transitions (hurt, death) that can occur in any state.
## Individual states handle input, movement, and animations.
class_name PlayerCharacter
extends CharacterBody2D

## Emitted when the player dies. The level or room manager
## should connect to this to handle game over.
signal died()

@onready var _sprite: Sprite2D = %Body
@onready var _hurtbox: HurtboxComponent = %HurtboxComponent
@onready var _hitbox: HitboxComponent = %HitboxComponent
@onready var _health: HealthComponent = %HealthComponent
@onready var _state_machine: StateMachine = %StateMachine


func _ready() -> void:
	add_to_group("player")

	# Connect signals
	_health.died.connect(_on_died)
	_hitbox.hit.connect(_on_hitbox_hit)

	_hitbox.enabled = false


func _process(_delta: float) -> void:
	_face_mouse()


## Flips the sprite horizontally so the player always faces the mouse.
## Runs every frame regardless of state to support kiting while attacking.
func _face_mouse() -> void:
	_sprite.flip_h = get_global_mouse_position().x < global_position.x


## Heals the player when the hitbox connects with an enemy.
func _on_hitbox_hit(_hurtbox: HurtboxComponent) -> void:
	_health.heal(2.0)


## Forces transition to Dead state and emits died signal.
func _on_died() -> void:
	_state_machine.transition_to("Dead")
	died.emit()


