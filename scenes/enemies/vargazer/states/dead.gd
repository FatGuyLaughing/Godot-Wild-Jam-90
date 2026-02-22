class_name EnemyVargazerDeadState
extends State

var vargazer: VargazerEnemy

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	if not vargazer:
		vargazer = entity as VargazerEnemy

	_animation_player.play("dead")
	_animation_player.animation_finished.connect(_on_animation_finished)

	vargazer._hurtbox.enabled = false
	vargazer._hitbox.enabled = false
	vargazer.set_deferred("collision_layer", 0)
	vargazer.set_deferred("collision_mask", 0)


func physics_process(_delta: float) -> void:
	_movement.apply_movement(vargazer, Vector2.ZERO)


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "dead":
		vargazer.queue_free()
