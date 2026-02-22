extends "res://scenes/game_scene/MainLevel/Rooms/rooms.gd"

const CREDITS_SCENE_PATH: String = "res://scenes/credits/scrolling_credits.tscn"


func _on_enemy_died() -> void:
	super._on_enemy_died()
	if room_cleared:
		get_tree().change_scene_to_file(CREDITS_SCENE_PATH)
