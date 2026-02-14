## A reusable hitbox component that deals damage to HurtboxComponents.
##
## Instance this scene as a child of any CharacterBody2D. Set [member entity_type]
## in the inspector to assign the correct physics layer and mask.
## The hitbox is the active scanner — it detects overlapping hurtboxes
## on the opposing team's hurtbox layer.
class_name HitboxComponent
extends Area2D

## Emitted when this hitbox overlaps a HurtboxComponent.
signal hit(hurtbox: HurtboxComponent)

enum EntityType {
	PLAYER,
	ENEMY
}

## Must match the layer numbers defined in project.godot [layer_names] 2d_physics.
const LAYER_PLAYER_HITBOX: int = 3
const LAYER_ENEMY_HITBOX: int = 6
const LAYER_PLAYER_HURTBOX: int = 4
const LAYER_ENEMY_HURTBOX: int = 7

## Determines which physics layer and mask this hitbox is assigned to.
@export var entity_type: EntityType = EntityType.PLAYER

## The amount of damage this hitbox deals to hurtboxes.
@export var damage: float = 10.0

## Toggles hit detection. Syncs with Area2D.monitoring so disabling
## this stops overlap detection immediately.
@export var enabled: bool = true :
	set(value):
		enabled = value
		monitoring = value


func _ready() -> void:
	_apply_physics_layer()
	area_entered.connect(_on_area_entered)


 ## Sets collision_layer and collision_mask based on entity_type.
 ## Player hitboxes scan for enemy hurtboxes, and vice versa.
func _apply_physics_layer() -> void:
	match entity_type:
		EntityType.PLAYER:
			collision_layer = 1 << (LAYER_PLAYER_HITBOX - 1)
			collision_mask = 1 << (LAYER_ENEMY_HURTBOX - 1)
		EntityType.ENEMY:
			collision_layer = 1 << (LAYER_ENEMY_HITBOX - 1)
			collision_mask = 1 << (LAYER_PLAYER_HURTBOX - 1)


## Handles overlap from any Area2D. Ignores non-HurtboxComponent areas.
func _on_area_entered(hurtbox: Area2D) -> void:
	if not enabled:
		return

	if not hurtbox is HurtboxComponent:
		return

	hit.emit(hurtbox)
