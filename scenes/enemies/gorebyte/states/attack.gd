class_name EnemyGorebyteAttackState
extends State

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _hitbox: HitboxComponent = %HitboxComponent
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_hitbox.enabled = true
	_animation_player.play("attack")
	_animation_player.animation_finished.connect(_on_animation_finished)


func physics_process(_delta: float) -> void:
	_movement.apply_movement(entity, Vector2.ZERO)


func exit() -> void:
	_hitbox.enabled = false
	_animation_player.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished(_animation_name: String) -> void:
	var gorebyte: GorebyteEnemy = entity as GorebyteEnemy

	if gorebyte.get_distance_to_player() <= gorebyte.attack_range:
		transition_to("Attack")
		return

	if gorebyte.player_in_range:
		transition_to("Chase")
		return

	transition_to("Idle")
