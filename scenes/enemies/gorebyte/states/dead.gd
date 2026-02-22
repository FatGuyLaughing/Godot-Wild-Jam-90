class_name EnemyGorebyteDeadState
extends State

const GOREBIT_SCENE: PackedScene = preload("res://scenes/enemies/gorebit/gorebit.tscn")

@export var spawn_offset: float = 20.0

var gorebyte: GorebyteEnemy
var pending_gorebits: Array[EnemyBase] = []

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	if not gorebyte:
		gorebyte = entity as GorebyteEnemy

	# Pre-create gorebits and register them with the room
	# so the enemy count is correct before the gorebyte's
	# died signal fires and decrements the counter.
	_prepare_gorebits()

	_animation_player.play("dead")
	_animation_player.animation_finished.connect(_on_animation_finished)

	gorebyte._hurtbox.enabled = false
	gorebyte._hitbox.enabled = false
	gorebyte.set_deferred("collision_layer", 0)
	gorebyte.set_deferred("collision_mask", 0)


func physics_process(_delta: float) -> void:
	_movement.apply_movement(gorebyte, Vector2.ZERO)


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "dead":
		_spawn_gorebits()
		gorebyte.queue_free()


func _prepare_gorebits() -> void:
	var offsets: Array[Vector2] = [
		Vector2(0, -1) * spawn_offset,
		Vector2(-0.866, 0.5) * spawn_offset,
		Vector2(0.866, 0.5) * spawn_offset,
	]

	pending_gorebits.clear()
	for offset in offsets:
		var gorebit = GOREBIT_SCENE.instantiate()
		gorebit.global_position = gorebyte.global_position + offset
		gorebit.aggro = true
		gorebit.player_ref = gorebyte.player_ref
		pending_gorebits.append(gorebit)

	var room = gorebyte.get_parent()
	if room.has_method("register_enemies"):
		room.register_enemies(pending_gorebits)


func _spawn_gorebits() -> void:
	var parent = gorebyte.get_parent()
	for gorebit in pending_gorebits:
		parent.call_deferred("add_child", gorebit)
	pending_gorebits.clear()
