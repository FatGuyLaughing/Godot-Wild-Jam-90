class_name EnemyGorebyteDeadState
extends State

const GOREBIT_SCENE: PackedScene = preload("res://scenes/enemies/gorebit/gorebit.tscn")

@export var spawn_offset: float = 20.0

var gorebyte: GorebyteEnemy

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	if not gorebyte:
		gorebyte = entity as GorebyteEnemy

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


func _spawn_gorebits() -> void:
	var parent = gorebyte.get_parent()
	var offsets: Array[Vector2] = [
		Vector2(0, -1) * spawn_offset,
		Vector2(-0.866, 0.5) * spawn_offset,
		Vector2(0.866, 0.5) * spawn_offset,
	]

	for offset in offsets:
		var gorebit = GOREBIT_SCENE.instantiate()
		gorebit.global_position = gorebyte.global_position + offset
		parent.call_deferred("add_child", gorebit)
