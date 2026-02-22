## Player dead state. Active when health reaches zero.
## The AnimationPlayer handles disabling combat components via keyframes.
## This is a terminal state — no transitions out.
class_name PlayerDeadState
extends State

const CREDITS_SCENE_PATH: String = "res://scenes/credits/scrolling_credits.tscn"

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func enter() -> void:
	entity.queue_free()
	get_tree().create_timer(1.0).timeout.connect(_go_to_credits)


func _go_to_credits() -> void:
	get_tree().change_scene_to_file(CREDITS_SCENE_PATH)
