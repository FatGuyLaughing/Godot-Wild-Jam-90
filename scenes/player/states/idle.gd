## Player idle state. Active when no movement input is detected.
## Transitions to Move on directional input and Attack on attack input.
class_name PlayerIdleState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func enter() -> void:
	_animation_player.play("idle")


func physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		transition_to("Move")
		return

	if Input.is_action_just_pressed("attack"):
		transition_to("MeleeAttack")
		return
