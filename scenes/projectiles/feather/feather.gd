## A feather projectile that travels toward the mouse position.
## Destroys itself on hitting a wall, an enemy, or when its lifetime expires.
class_name Feather
extends CharacterBody2D

## Set by the ranged attack state before adding to the scene.
var direction: Vector2 = Vector2.ZERO

## Speed of the projectile in pixels per second.
@export var speed: float = 300.0

## How long the projectile lives before self-destructing.
@export var lifetime: float = 3.0

@onready var _hitbox: HitboxComponent = %HitboxComponent
@onready var _lifetime_timer: Timer = %LifetimeTimer


func _ready() -> void:
	_hitbox.hit.connect(_on_hitbox_hit)
	_lifetime_timer.wait_time = lifetime
	_lifetime_timer.one_shot = true
	_lifetime_timer.start()
	_lifetime_timer.timeout.connect(_on_lifetime_timeout)
	# Rotate sprite to face the travel direction
	rotation = direction.angle()


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	var collided: bool = move_and_slide()

	# Wall collision — destroy on impact
	if collided:
		queue_free()


## Destroy on hitting an enemy hurtbox. Damage is handled by the hurtbox/health system.
func _on_hitbox_hit(_hurtbox: HurtboxComponent) -> void:
	queue_free()


## Self-destruct if the feather doesn't hit anything.
func _on_lifetime_timeout() -> void:
	queue_free()
