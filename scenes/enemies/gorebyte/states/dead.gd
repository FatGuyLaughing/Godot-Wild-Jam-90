class_name EnemyGorebyteDeadState
extends State

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
		gorebyte.queue_free()
