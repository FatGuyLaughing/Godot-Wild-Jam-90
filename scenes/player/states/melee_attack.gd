## Player melee attack state. Active when the player initiates a melee attack.
## The AnimationPlayer drives the hitbox enable/disable via keyframes.
## Transitions to RangedAttack, Move, or Idle when the animation finishes.
class_name PlayerMeleeAttackState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent
@onready var _hitbox: HitboxComponent = %HitboxComponent


func enter() -> void:
	_hitbox.enabled = true
	_animation_player.play("attack")
	_animation_player.animation_finished.connect(_on_animation_finished)


## Allows the player to move while attacking.
func physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_movement.apply_movement(entity, direction)


func exit() -> void:
	_hitbox.enabled = false
	_animation_player.animation_finished.disconnect(_on_animation_finished)


## Checks for attack chaining first, then directional input, to determine
## the next state after the melee animation finishes.
func _on_animation_finished(_animation_name: String) -> void:
	if Input.is_action_just_pressed("ranged_attack"):
		transition_to("RangedAttack")
		return

	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		transition_to("Move")
	else:
		transition_to("Idle")
