## Player dead state. Active when health reaches zero.
## The AnimationPlayer handles disabling combat components via keyframes.
## This is a terminal state — no transitions out.
class_name PlayerDeadState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func enter() -> void:
	_animation_player.play("dead")
