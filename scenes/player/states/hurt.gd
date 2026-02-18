## Player hurt state. Active when the player takes damage.
## Plays the hurt animation and transitions out when it finishes.
class_name PlayerHurtState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_animation_player.play("hurt")
	_animation_player.animation_finished.connect(_on_animation_finished)


func physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_movement.apply_movement(entity, direction)


func exit() -> void:
	_animation_player.animation_finished.disconnect(_on_animation_finished)


## Checks for attack input first, then directional input, to determine
## the next state after the hurt animation finishes.
func _on_animation_finished(_animation_name: String) -> void:
	if Input.is_action_just_pressed("attack"):
		transition_to("Attack")
		return

	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		transition_to("Move")
	else:
		transition_to("Idle")
