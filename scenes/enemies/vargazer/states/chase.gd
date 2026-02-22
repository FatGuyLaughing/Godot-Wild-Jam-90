class_name VargazerChaseState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_animation_player.play("move")


func physics_process(_delta: float) -> void:
	var vargazer: VargazerEnemy = entity as VargazerEnemy

	if not vargazer.aggro and not vargazer.player_in_range:
		transition_to("Idle")
		return

	if vargazer.player_in_range and vargazer.player_in_sight:
		transition_to("RangedAttack")
		return

	var direction: Vector2 = vargazer.get_direction_to_player()
	vargazer.face_direction(direction)
	_movement.apply_movement(entity, direction)
