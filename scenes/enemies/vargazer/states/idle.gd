class_name VargazerIdleState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func enter() -> void:
	_animation_player.play("idle")


func physics_process(_delta: float) -> void:
	var enemy: EnemyBase = entity as EnemyBase
	if enemy.player_in_range and enemy.player_in_sight:
		enemy.aggro = true
		transition_to("RangedAttack")
