## Player move state. Active when directional input is detected.
## Transitions to Idle when input stops, MeleeAttack or RangedAttack
## on their respective inputs.
class_name PlayerMoveState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_animation_player.play("move")


func physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction == Vector2.ZERO:
		transition_to("Idle")
		return

	if Input.is_action_just_pressed("attack"):
		transition_to("MeleeAttack")
		return

	if Input.is_action_just_pressed("ranged_attack"):
		transition_to("RangedAttack")
		return

	# Only apply movement if we're not transitioning out
	_movement.apply_movement(entity, direction)
