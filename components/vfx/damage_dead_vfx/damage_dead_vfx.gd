extends GPUParticles2D

@export var knockback_component: KnockbackComponent

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	emitting = false
	gpu_particles_2d.emitting = false
	one_shot = true
	gpu_particles_2d.one_shot = true

	if is_instance_valid(knockback_component):
		knockback_component.knockback_applied.connect(_on_knockback_applied)

	get_parent().died.connect(_on_died, CONNECT_DEFERRED)


func _on_knockback_applied(velocity: Vector2) -> void:
	process_material.direction = Vector3(velocity.x, velocity.y, 0)
	emitting = true


func _on_died() -> void:
	var scene := get_tree().current_scene if get_tree() else null
	if not is_instance_valid(scene):
		return
	gpu_particles_2d.reparent(scene)
	gpu_particles_2d.process_material = gpu_particles_2d.process_material.duplicate()
	gpu_particles_2d.process_material.direction = Vector3(0, -1, 0)
	gpu_particles_2d.emitting = true
	get_tree().create_timer(gpu_particles_2d.lifetime + .5).timeout.connect(gpu_particles_2d.queue_free)
