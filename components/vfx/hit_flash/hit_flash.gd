class_name HitFlashComponent
extends Node

@export var hurtbox: HurtboxComponent
@export var sprite: Sprite2D
@export var flash_duration: float = 0.15


func _ready() -> void:
	if sprite.material:
		sprite.material = sprite.material.duplicate()
	hurtbox.hit.connect(_on_hurtbox_hit)


func _on_hurtbox_hit(_hitbox: HitboxComponent, _damage: float) -> void:
	flash()


func flash() -> void:
	var material: ShaderMaterial = sprite.material as ShaderMaterial
	if not material:
		return
	material.set_shader_parameter("flash_intensity", 1.0)
	var tween: Tween = create_tween()
	tween.tween_property(material, "shader_parameter/flash_intensity", 0.0, flash_duration)
