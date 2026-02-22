extends Node2D

const CREDITS_SCENE_PATH: String = "res://scenes/credits/scrolling_credits.tscn"

@onready var _player: PlayerCharacter = $PlayerCharacter


func _ready() -> void:
	_player.died.connect(_on_player_died)


func _on_player_died() -> void:
	get_tree().create_timer(1.0).timeout.connect(
		func() -> void:
			get_tree().change_scene_to_file(CREDITS_SCENE_PATH)
	)
