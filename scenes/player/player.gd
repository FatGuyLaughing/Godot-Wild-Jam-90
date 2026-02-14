## The playable character. Handles attack input and responds to
## health and knockback component signals.
class_name PlayerCharacter
extends CharacterBody2D

## Emitted when the player dies. The level or room manager
## should connect to this to handle game over.
signal died()

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _hurtbox: HurtboxComponent = %HurtboxComponent
@onready var _hitbox: HitboxComponent = %HitboxComponent
@onready var _health: HealthComponent = %HealthComponent


func _ready() -> void:
	_health.died.connect(_on_died)
	_hitbox.enabled = false


func _on_died() -> void:
	_hurtbox.enabled = false
	_hitbox.enabled = false
	died.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		_attack()


func _attack() -> void:
	_animation_player.play("attack")
