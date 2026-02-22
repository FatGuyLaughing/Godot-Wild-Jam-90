class_name EnemyGorebyteChaseState
extends State

var _boss_spawn_timer: float = 0.0

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_animation_player.play("move")
	var gorebyte: GorebyteEnemy = entity as GorebyteEnemy
	if gorebyte.is_boss:
		_boss_spawn_timer = randf_range(5.0, 10.0)


func physics_process(delta: float) -> void:
	var gorebyte: GorebyteEnemy = entity as GorebyteEnemy

	if gorebyte.is_boss:
		_boss_spawn_timer -= delta
		if _boss_spawn_timer <= 0.0:
			transition_to("BossSpawn")
			return

	if not gorebyte.player_in_range:
		transition_to("Idle")
		return

	if gorebyte.get_distance_to_player() <= gorebyte.attack_range:
		transition_to("Attack")
		return

	var direction: Vector2 = gorebyte.get_direction_to_player()
	gorebyte.face_direction(direction)
	_movement.apply_movement(entity, direction)
