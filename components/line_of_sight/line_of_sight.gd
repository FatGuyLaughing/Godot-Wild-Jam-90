class_name LineOfSightComponent extends RayCast2D
## LineOfSight component provide a check(target) method that returns whether
## a target body, area, or target's HurtboxComponent is the first collision
## with a RayCast2D from the component owner (actor).
##
## Collision mask must be configured!


## Node2D this component belongs to
@export var actor: Node2D:
	get():
		if not is_instance_valid(actor):
			actor = get_parent()
		return actor

## Sets exceptions (not normally needed)
@export var ignored_collision_objects: Array[CollisionObject2D]:
	set(v):
		clear_exceptions()
		for collider: CollisionObject2D in ignored_collision_objects:
			add_exception(collider)

# Just used for visual debugging in _process
var target: Node2D


func _ready() -> void:
	# force_raycast_update() works even when raycast is disabled
	enabled = false
	collide_with_areas = true


func _process(_delta: float) -> void:
	# This is just helpful for visualization in debug play
	if OS.has_feature("debug") and is_instance_valid(target):
		target_position = target.global_position - actor.global_position


func check(_target: Node2D) -> bool:
	# before the first physics frame completes, world collisions may be incorrect
	if Engine.get_physics_frames() < 2:
		return false
	#prints(actor.name, "checking los to", _target.name)
	target = _target
	if not is_instance_valid(owner):
		push_warning("LineOfSightComponent.check() requires valid owner")
		return false
	if not is_instance_valid(target):
		push_warning("LineOfSightComponent.check() requires valid target")
		return false
	target_position = target.global_position - actor.global_position

	force_raycast_update()

	var collider: Node2D = get_collider()
	if not collider:
		prints("no collision")
		return false
	if collider == target:
		#prints(actor.name, "has line of sight to", collider.name)
		return true
	if collider is HurtboxComponent and collider.owner == target:
		#prints(actor.name, "has line of sight to", collider.owner.name)
		return true
	return false
