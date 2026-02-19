class_name EnemyGorebitDeadState
extends State

var gorebit: GorebitEnemy

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	if not gorebit:
		gorebit = entity as GorebitEnemy

	_animation_player.play("dead")
	_animation_player.animation_finished.connect(_on_animation_finished)

	gorebit._hurtbox.enabled = false
	gorebit._hitbox.enabled = false
	gorebit.set_deferred("collision_layer", 0)
	gorebit.set_deferred("collision_mask", 0)


func physics_process(_delta: float) -> void:
	_movement.apply_movement(gorebit, Vector2.ZERO)


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "dead":
		gorebit.queue_free()
