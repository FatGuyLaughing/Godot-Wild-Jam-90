class_name EnemyGorebitHurtState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_animation_player.play("hurt")
	_animation_player.animation_finished.connect(_on_animation_finished)


func physics_process(_delta: float) -> void:
	_movement.apply_movement(entity, Vector2.ZERO)


func exit() -> void:
	_animation_player.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished(animation_name: String) -> void:
	var gorebit: GorebitEnemy = entity as GorebitEnemy

	if gorebit.player_in_range:
		transition_to("Chase")
	else:
		transition_to("Idle")
