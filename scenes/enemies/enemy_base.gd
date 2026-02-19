class_name EnemyBase
extends CharacterBody2D

signal died()

var player_ref: PlayerCharacter = null
var player_in_range: bool = false
var player_in_sight: bool = false

@onready var _sprite: Sprite2D = %Sprite2D
@onready var _hurtbox: HurtboxComponent = %HurtboxComponent
@onready var _hitbox: HitboxComponent = %HitboxComponent
@onready var _health: HealthComponent = %HealthComponent
@onready var _line_of_sight: LineOfSightComponent = $LineOfSightComponent
@onready var _state_machine: StateMachine = %StateMachine
@onready var _detection_zone: Area2D = %DetectionZone


func _ready() -> void:
	add_to_group("enemies")
	_hurtbox.hit.connect(_on_hurtbox_hit)
	_health.died.connect(_on_died)
	_hitbox.enabled = false
	_detection_zone.body_entered.connect(_on_detection_zone_body_entered)
	_detection_zone.body_exited.connect(_on_detection_zone_body_exited)


func _physics_process(_delta: float) -> void:
	if is_instance_valid(player_ref):
		player_in_sight = _line_of_sight.check(player_ref)


func _on_died() -> void:
	_state_machine.transition_to("Dead")
	died.emit()


func _on_hurtbox_hit(_incoming_hitbox: HitboxComponent, _damage: float) -> void:
	_state_machine.transition_to("Hurt")


func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = body as PlayerCharacter
		player_in_range = true


func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		#TODO - Should we reset player_ref to null
		player_in_range = false


func get_direction_to_player() -> Vector2:
	if player_ref and is_instance_valid(player_ref):
		return global_position.direction_to(player_ref.global_position)

	return Vector2.ZERO


func get_distance_to_player() -> float:
	if player_ref and is_instance_valid(player_ref):
		return global_position.distance_to(player_ref.global_position)

	return INF


func face_direction(direction: Vector2) -> void:
	if direction.x != 0:
		_sprite.flip_h = direction.x > 0
