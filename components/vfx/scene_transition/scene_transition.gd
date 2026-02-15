extends CanvasLayer
## A scene transition shader based on BinBun's
## https://godotshaders.com/shader/transition-shader-with-patterns/
##
## Should be added as a Global/Autoload for smooth scene changes
##
## Example use
##
##   await <AutoloadName>.fade_out()
##   get_tree().change_scene_to_file(...)
##
##   [in new scene script]
##   if <AutoloadName>.is_hiding_scene():
##     await <AutoloadName>.fade_in()
##

const IN_TEXTURE: Texture2D = preload("res://components/vfx/scene_transition/gradients/feather_transition_gradient_v2.png")
const OUT_TEXTURE: Texture2D = preload("res://components/vfx/scene_transition/gradients/feather_transition_gradient_v2_inverted.png")

var tween: Tween

@onready var color_rect: TransitionRect = $TransitionRect


func _ready() -> void:
	layer = RenderingServer.CANVAS_LAYER_MAX  ## Always draw on top
	color_rect.material.set_shader_parameter("factor", 0.0)
	if get_tree().current_scene == self:
		demo.call_deferred()
	else:
		$MarginContainer.queue_free()


func is_hiding_scene() -> bool:
	return color_rect.material.get_shader_parameter("factor") != 0


func fade_in(duration: float = 1.0) -> Signal:
	if tween:
		tween.kill()
	color_rect.material.set_shader_parameter("gradient_texture", IN_TEXTURE)
	color_rect.material.set_shader_parameter("factor", 1.0)
	tween = create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/factor", 0.0, duration)
	return tween.finished


func fade_out(duration: float = 1.0) -> Signal:
	if tween:
		tween.kill()
	color_rect.material.set_shader_parameter("gradient_texture", OUT_TEXTURE)
	color_rect.material.set_shader_parameter("factor", 0.0)
	tween = create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/factor", 1.0, duration)
	return tween.finished


func demo() -> void:
	await get_tree().create_timer(2.0).timeout
	await fade_out()
	await fade_in()
	demo.call_deferred()
