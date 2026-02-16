extends Node2D  # or your root node type

# Example room state variables you want to save
var enemy_positions := []
var puzzle_solved := false
@export var room_id: String = "Room1"


# Called by RoomManager after the room is instanced
func load_state(state: Dictionary) -> void:
	if "enemy_positions" in state:
		enemy_positions = state["enemy_positions"]
		# Update enemies positions here accordingly
	if "puzzle_solved" in state:
		puzzle_solved = state["puzzle_solved"]
		# Update puzzle visuals here accordingly
	print("Room loaded state:", state)

# Called by RoomManager before the room is freed
func save_state() -> Dictionary:
	var state = {}
	state["enemy_positions"] = enemy_positions
	state["puzzle_solved"] = puzzle_solved
	print("Room saved state:", state)
	return state
