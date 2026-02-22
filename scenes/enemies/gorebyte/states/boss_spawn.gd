class_name EnemyGorebyteBossSpawnState
extends State

const GOREBIT_SCENE: PackedScene = preload("res://scenes/enemies/gorebit/gorebit.tscn")

@export var spawn_offset: float = 20.0

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent
@onready var _hitbox: HitboxComponent = %HitboxComponent


func enter() -> void:
	_hitbox.enabled = false
	_animation_player.play("attack")
	_animation_player.animation_finished.connect(_on_animation_finished)


func exit() -> void:
	_hitbox.enabled = true
	_animation_player.animation_finished.disconnect(_on_animation_finished)


func physics_process(_delta: float) -> void:
	_movement.apply_movement(entity, Vector2.ZERO)


func _on_animation_finished(_animation_name: String) -> void:
	var gorebyte: GorebyteEnemy = entity as GorebyteEnemy
	var count: int = randi_range(1, 2)
	var gorebits: Array[EnemyBase] = []

	for i in count:
		var angle: float = randf() * TAU
		var offset: Vector2 = Vector2.from_angle(angle) * spawn_offset
		var gorebit = GOREBIT_SCENE.instantiate()
		gorebit.global_position = gorebyte.global_position + offset
		gorebit.aggro = true
		gorebit.player_ref = gorebyte.player_ref
		gorebits.append(gorebit)

	var room = gorebyte.get_parent()
	if room.has_method("register_enemies"):
		room.register_enemies(gorebits)

	for gorebit in gorebits:
		room.call_deferred("add_child", gorebit)

	if gorebyte.player_in_range:
		transition_to("Chase")
	else:
		transition_to("Idle")
