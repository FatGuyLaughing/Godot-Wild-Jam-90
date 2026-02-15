## Player attack state. Active when the player initiates an attack.
## The AnimationPlayer drives the hitbox enable/disable via keyframes.
## Transitions to Move or Idle when the attack animation finishes.
class_name PlayerMeleeAttackState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func enter() -> void:
	_animation_player.play("attack")
	_animation_player.animation_finished.connect(_on_animation_finished)


func exit() -> void:
	_animation_player.animation_finished.disconnect(_on_animation_finished)


## Checks for directional input after the attack to determine
## whether to transition to Move or Idle.
func _on_animation_finished(_animation_name: String) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		transition_to("Move")
	else:
		transition_to("Idle")
