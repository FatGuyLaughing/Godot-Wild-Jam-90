class_name EnemyGorebitIdleState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func enter() -> void:
	_animation_player.play("idle")


func physics_process(_delta: float) -> void:
	var gorebit: GorebitEnemy = entity as GorebitEnemy
	if gorebit.is_airborne:
		return
	if gorebit.aggro:
		transition_to("Chase")
		return
	if gorebit.player_in_range and gorebit.player_in_sight:
		transition_to("Chase")
