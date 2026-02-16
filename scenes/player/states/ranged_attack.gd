## Player ranged attack state. Active when the player initiates a ranged attack.
## Costs health to use. Spawns a feather projectile aimed at the mouse position.
## Supports rapid fire controlled by [member attack_cooldown].
## Transitions to MeleeAttack, Move, or Idle when the animation finishes.
class_name PlayerRangedAttackState
extends State

## The health cost per ranged attack.
@export var health_cost: float = 5.0

## Minimum health required to use ranged attack.
@export var min_health_threshold: float = 20.0

## Time in seconds between ranged attacks. Tune this to control fire rate.
@export var attack_cooldown: float = 0.2

## The feather projectile scene to spawn.
@export var projectile_scene: PackedScene

var _cooldown_remaining: float = 0.0

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _health: HealthComponent = %HealthComponent
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_cooldown_remaining = attack_cooldown
	_health.take_damage(health_cost)
	_animation_player.play("ranged_attack")
	_animation_player.animation_finished.connect(_on_animation_finished)
	_spawn_projectile()


## Allows the player to move while attacking. Checks for ranged attack
## chaining based on cooldown timer rather than animation completion.
func physics_process(delta: float) -> void:
	_cooldown_remaining -= delta

	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_movement.apply_movement(entity, direction)

	if Input.is_action_just_pressed("ranged_attack") and can_attack() and _cooldown_remaining <= 0.0:
		transition_to("RangedAttack")


func exit() -> void:
	_animation_player.animation_finished.disconnect(_on_animation_finished)


## Returns true if the player has enough health to use ranged attack.
func can_attack() -> bool:
	return _health.get_current_health() > min_health_threshold


## Spawns a feather projectile at the player's position aimed at the mouse.
## The projectile is added to the current scene so it persists independently.
func _spawn_projectile() -> void:
	var projectile: Node2D = projectile_scene.instantiate()
	projectile.global_position = entity.global_position
	projectile.direction = entity.global_position.direction_to(entity.get_global_mouse_position())
	entity.get_tree().current_scene.add_child(projectile)


## Handles the case where the player stopped pressing ranged attack.
## Checks for melee chaining, then directional input.
func _on_animation_finished(_animation_name: String) -> void:
	if Input.is_action_pressed("attack"):
		transition_to("MeleeAttack")
		return

	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		transition_to("Move")
	else:
		transition_to("Idle")
