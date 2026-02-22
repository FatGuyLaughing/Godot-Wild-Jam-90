class_name EnemyGorebyteIdleState
extends State

var _boss_spawn_timer: float = 0.0

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func enter() -> void:
	_animation_player.play("idle")
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

	if gorebyte.player_in_range and gorebyte.player_in_sight:
		transition_to("Chase")
