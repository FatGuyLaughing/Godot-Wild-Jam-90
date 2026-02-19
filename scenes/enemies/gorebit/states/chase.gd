class_name EnemyGorebitChaseState
extends State

@export var leash_distance: float = 200.0

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_animation_player.play("chase")


func physics_process(_delta: float) -> void:
	var gorebit: GorebitEnemy = entity as GorebitEnemy
	var distance: float = gorebit.get_distance_to_player()

	if distance > leash_distance:
		transition_to("Idle")
		return

	if distance <= gorebit.attack_range:
		transition_to("Attack")
		return

	var direction: Vector2 = gorebit.get_direction_to_player()
	gorebit.face_direction(direction)
	_movement.apply_movement(entity, direction)
