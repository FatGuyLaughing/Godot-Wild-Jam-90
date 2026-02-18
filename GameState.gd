extends Node

var rooms_data: Dictionary = {}

func save_room_state(room_id: String, state: Dictionary) -> void:
	rooms_data[room_id] = state
	print("Saved state for room:", room_id)

func load_room_state(room_id: String) -> Dictionary:
	if rooms_data.has(room_id):
		print("Loaded state for room:", room_id)
		return rooms_data[room_id]
	else:
		print("No saved state for room:", room_id)
		return {}
