class_name EnemyGorebyteChaseState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_animation_player.play("move")


func physics_process(_delta: float) -> void:
	var gorebyte: GorebyteEnemy = entity as GorebyteEnemy

	if not gorebyte.player_in_range:
		transition_to("Idle")
		return

	if gorebyte.get_distance_to_player() <= gorebyte.attack_range:
		transition_to("Attack")
		return

	var direction: Vector2 = gorebyte.get_direction_to_player()
	gorebyte.face_direction(direction)
	_movement.apply_movement(entity, direction)
