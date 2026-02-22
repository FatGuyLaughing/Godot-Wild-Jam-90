class_name EnemyGorebitChaseState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_animation_player.play("move")


func physics_process(_delta: float) -> void:
	var gorebit: GorebitEnemy = entity as GorebitEnemy

	if not gorebit.aggro and not gorebit.player_in_range:
		transition_to("Idle")
		return

	if gorebit.get_distance_to_player() <= gorebit.attack_range:
		transition_to("Attack")
		return

	var direction: Vector2 = gorebit.get_direction_to_player()
	gorebit.face_direction(direction)
	_movement.apply_movement(entity, direction)
