## Player ranged attack state. Active when the player initiates a ranged attack.
## Costs health to use. Spawns a feather projectile aimed at the mouse position.
## Transitions to MeleeAttack, Move, or Idle when the animation finishes.
class_name PlayerRangedAttackState
extends State

## The health cost per ranged attack.
@export var health_cost: float = 5.0

## Minimum health required to use ranged attack.
@export var min_health_threshold: float = 20.0

## The feather projectile scene to spawn.
@export var projectile_scene: PackedScene

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _health: HealthComponent = %HealthComponent
@onready var _movement: MovementComponent = %MovementComponent


func enter() -> void:
	_health.take_damage(health_cost)
	_animation_player.play("ranged_attack")
	_animation_player.animation_finished.connect(_on_animation_finished)
	_spawn_projectile()


## Allows the player to move while attacking.
func physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_movement.apply_movement(entity, direction)


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


## Checks for attack chaining first, then directional input, to determine
## the next state after the ranged animation finishes.
func _on_animation_finished(_animation_name: String) -> void:
	if Input.is_action_pressed("attack"):
		transition_to("MeleeAttack")
		return

	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		transition_to("Move")
	else:
		transition_to("Idle")
