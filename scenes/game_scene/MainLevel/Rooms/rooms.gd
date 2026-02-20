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
		$fog.queue_free()

	# -----------------------------
	# FOG STATE INTEGRATION
	# -----------------------------
	if state.has("fog_activated"):
		var fog_trigger = get_node_or_null("fogtest")
		if fog_trigger:
			fog_trigger.activated = state["fog_activated"]

			# If fog was already activated before,
			# remove the fog visual safely
			if fog_trigger.activated:
				var fog_node = get_node_or_null("fog")
				if fog_node:
					fog_node.queue_free()

	print("Room loaded state:", state)


func save_state() -> Dictionary:
	var state: Dictionary = {}

	state["enemy_positions"] = enemy_positions
	state["puzzle_solved"] = puzzle_solved

	# -----------------------------
	# FOG STATE INTEGRATION
	# -----------------------------
	var fog_trigger = get_node_or_null("fogtest")
	if fog_trigger:
		state["fog_activated"] = fog_trigger.activated

	print("Room saved state:", state)
	return state
