class_name PlayerDeadState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer

func enter() -> void:
	_animation_player.play("dead")
