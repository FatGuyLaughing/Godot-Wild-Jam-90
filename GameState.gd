extends Node

# Store saved data for rooms: dictionary of room name -> saved state dict
var rooms_data := {}

# Save state of a room by name
func save_room_state(room_name: String, state: Dictionary) -> void:
	rooms_data[room_name] = state
	print("Saved state for room: ", room_name)

# Load state of a room by name (returns Dictionary or empty dictionary)
func load_room_state(room_name: String) -> Dictionary:
	if room_name in rooms_data:
		print("Loaded state for room: ", room_name)
		return rooms_data[room_name]
	else:
		print("No saved state for room: ", room_name)
		return {}
