class_name EnemyGorebitAttackState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_animation_player.play("attack")
	_animation_player.animation_finished.connect(_on_animation_finished)


func physics_process(_delta: float) -> void:
	_movement.apply_movement(entity, Vector2.ZERO)


func exit() -> void:
	_animation_player.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished(_animation_name: String) -> void:
	var gorebit: GorebitEnemy = entity as GorebitEnemy

	if gorebit.get_distance_to_player() <= gorebit.attack_range:
		transition_to("Attack")
		return

	if gorebit.player_in_range:
		transition_to("Chase")
		return

	transition_to("Idle")
