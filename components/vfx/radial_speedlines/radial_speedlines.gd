extends CanvasLayer
## A screen shader that adds first-person "speed lines."
##
## Call speed_in() to add the effect
## Call speed_out() to remove the effect
##
## The shake and motion (rotation) of the lines are handled in _process
## Other shader parameters are tweened

@export var max_shake_intensity: float = 1
@export var rotation_speed: float = 50

var shake_intensity: float = 0
var tween: Tween

@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	# demo
	if get_tree().current_scene == self:
		speed_in.call_deferred()
		get_tree().create_timer(4.0).timeout.connect(speed_out)


func _process(delta: float) -> void:
	var x: float = randf_range(-max_shake_intensity, shake_intensity)
	var y: float = randf_range(-shake_intensity, shake_intensity)
	var motion: Vector2 = Vector2(0.5 + x, 0.5 + y)
	var center: Vector2 = Vector2(0.5, 0.5).lerp(motion, delta)
	color_rect.material.set_shader_parameter("center", center)
	color_rect.material.get_shader_parameter("noise").noise.offset.y += delta * rotation_speed
	if color_rect.material.get_shader_parameter("noise").noise.offset.y > 10000:
		color_rect.material.get_shader_parameter("noise").noise.offset.y = 0


func reset() -> void:
	shake_intensity = 0
	color_rect.modulate = Color.TRANSPARENT
	color_rect.material.set_shader_parameter("center_radius", 0.0)
	color_rect.material.set_shader_parameter("lines_end", 0.0)
	color_rect.material.set_shader_parameter("sample_radius", 1.0)
	color_rect.material.get_shader_parameter("noise").noise.seed = randi_range(0, 10000)


func speed_in(blend_duration: float = 3.0) -> void:
	if tween:
		tween.kill()
	reset()
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(color_rect, "modulate", Color.WHITE, blend_duration / 2.0)
	tween.tween_property(
		color_rect.material, "shader_parameter/lines_end", 0.7, blend_duration / 2.0
	)
	tween.chain().tween_property(self, "shake_intensity", max_shake_intensity, blend_duration / 2.0)


func speed_out(blend_duration: float = 0.2) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.chain().tween_property(self, "shake_intensity", 0.0, blend_duration)
	tween.tween_property(color_rect.material, "shader_parameter/lines_end", 0.0, blend_duration)
	tween.tween_property(color_rect, "modulate", Color.TRANSPARENT, blend_duration)

	# demo
	if get_tree().current_scene == self:
		await tween.finished
		reset()
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()
