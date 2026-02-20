class_name VargazerIdleState
extends State


func enter() -> void:
	print("Vargazer state Idle")


func physics_process(_delta: float) -> void:
	if entity.player_in_range and entity.player_in_sight:
		transition_to("RangedAttack")
