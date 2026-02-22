## Player ranged attack state. Active when the player initiates a ranged attack.
## Costs health to use. Spawns a feather projectile aimed at the mouse position.
## Transitions immediately to Move or Idle after spawning.
class_name PlayerRangedAttackState
extends State

## The health cost per ranged attack.
@export var health_cost: float = 5.0

## Minimum health required to use ranged attack.
@export var min_health_threshold: float = 20.0

## The feather projectile scene to spawn.
@export var projectile_scene: PackedScene

@onready var _health: HealthComponent = %HealthComponent
@onready var _spawn_point: Marker2D = %ProjectileSpawnPoint


func enter() -> void:
	_health.take_damage(health_cost)
	_spawn_projectile()

	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		transition_to("Move")
	else:
		transition_to("Idle")


## Returns true if the player has enough health to use ranged attack.
func can_attack() -> bool:
	return _health.get_current_health() > min_health_threshold


## Spawns a feather projectile at the player's position aimed at the mouse.
## The projectile is added to the current scene so it persists independently.
func _spawn_projectile() -> void:
	var projectile: Node2D = projectile_scene.instantiate()
	projectile.direction = _spawn_point.global_position.direction_to(entity.get_global_mouse_position())
	entity.get_tree().current_scene.add_child(projectile)
	projectile.global_position = _spawn_point.global_position
	projectile.rotation = projectile.direction.angle()
