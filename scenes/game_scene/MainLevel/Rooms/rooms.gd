extends Node2D

@export var room_id: String = "Room1"

var enemy_positions: Array = []
var puzzle_solved: bool = false

func load_state(state: Dictionary) -> void:
	if state.is_empty():
		return

	if state.has("enemy_positions"):
		enemy_positions = state["enemy_positions"]
		# TODO: Apply positions to enemies here

	if state.has("puzzle_solved"):
		puzzle_solved = state["puzzle_solved"]
		# TODO: Update puzzle visuals here

	print("Room loaded state:", state)

func save_state() -> Dictionary:
	var state: Dictionary = {}
	state["enemy_positions"] = enemy_positions
	state["puzzle_solved"] = puzzle_solved

	print("Room saved state:", state)
	return state
