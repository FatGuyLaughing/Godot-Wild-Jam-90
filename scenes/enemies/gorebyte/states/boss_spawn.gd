class_name EnemyGorebyteBossSpawnState
extends State

const GOREBIT_SCENE: PackedScene = preload("res://scenes/enemies/gorebit/gorebit.tscn")
const ARC_HEIGHT: float = 40.0
const ARC_DURATION: float = 0.5
const MIN_SPREAD: float = 20.0
const MAX_SPREAD: float = 40.0

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent
@onready var _hitbox: HitboxComponent = %HitboxComponent

var _target_position: Vector2
var _tweens_remaining: int = 0


func enter() -> void:
	_hitbox.enabled = false
	var gorebyte: GorebyteEnemy = entity as GorebyteEnemy
	if is_instance_valid(gorebyte.player_ref):
		_target_position = gorebyte.player_ref.global_position
	else:
		_target_position = gorebyte.global_position
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
		var gorebit: GorebitEnemy = GOREBIT_SCENE.instantiate()
		gorebit.global_position = gorebyte.global_position
		gorebit.aggro = true
		gorebit.player_ref = gorebyte.player_ref
		gorebit.is_airborne = true
		gorebits.append(gorebit)

	var room = gorebyte.get_parent()
	if room.has_method("register_enemies"):
		room.register_enemies(gorebits)

	_tweens_remaining = count

	# Pre-calculate landing positions with guaranteed spacing
	var landing_positions: Array[Vector2] = []
	var base_angle: float = randf() * TAU
	for i in count:
		var angle: float = base_angle + (TAU / count) * i
		var dist: float = randf_range(MIN_SPREAD, MAX_SPREAD) * 0.5
		landing_positions.append(_target_position + Vector2.from_angle(angle) * dist)

	for i in gorebits.size():
		var gorebit: GorebitEnemy = gorebits[i]
		room.call_deferred("add_child", gorebit)

		var end_pos := landing_positions[i]
		var start_pos := gorebyte.global_position

		# Tween the arc — deferred so gorebit is in the tree and @onready vars are set
		var _launch := func() -> void:
			# Store and disable collision now that _ready() has run
			var saved_collision_layer := gorebit.collision_layer
			var saved_collision_mask := gorebit.collision_mask
			gorebit.collision_layer = 0
			gorebit.collision_mask = 0
			gorebit._hurtbox.enabled = false

			var tween := gorebit.create_tween()
			tween.tween_method(func(t: float) -> void:
				gorebit.global_position = start_pos.lerp(end_pos, t)
				gorebit._sprite.position.y = -sin(t * PI) * ARC_HEIGHT
			, 0.0, 1.0, ARC_DURATION)
			tween.tween_callback(func() -> void:
				gorebit._sprite.position.y = 0.0
				gorebit.collision_layer = saved_collision_layer
				gorebit.collision_mask = saved_collision_mask
				gorebit._hurtbox.enabled = true
				gorebit.is_airborne = false
				_tweens_remaining -= 1
				if _tweens_remaining <= 0:
					_on_all_landed()
			)

		gorebit.ready.connect(_launch, CONNECT_ONE_SHOT)


func _on_all_landed() -> void:
	var gorebyte: GorebyteEnemy = entity as GorebyteEnemy
	if gorebyte.player_in_range:
		transition_to("Chase")
	else:
		transition_to("Idle")
