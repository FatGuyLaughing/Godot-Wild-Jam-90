extends Node2D

# Unique ID for this room (used by RoomManager + GameState)
@export var room_id: String = "Room1"

# Tracks how many enemies are still alive in THIS room
var remaining_enemies: int = 0

# True when all enemies in this room are defeated
var room_cleared: bool = false

# Optional: if you're saving enemy positions
var enemy_positions: Array = []


# --------------------------------------------------
# Called automatically when the room enters scene tree
# --------------------------------------------------
func _ready():
	setup_enemies()

	# If the room was already cleared previously,
	# remove the fog immediately when entering
	if room_cleared:
		remove_fog()


# --------------------------------------------------
# Finds all enemies inside this room and connects
# their death signals
# --------------------------------------------------
func setup_enemies():
	remaining_enemies = 0

	# We only check direct children of this room
	# So this works independently per room
	for child in get_children():
		if child.is_in_group("enemies"):
			remaining_enemies += 1

			# Connect enemy death signal to this room
			# (Avoid double-connecting if reloaded)
			if not child.died.is_connected(_on_enemy_died):
				child.died.connect(_on_enemy_died)

	# If a room starts with no enemies,
	# remove fog immediately
	if remaining_enemies == 0:
		room_cleared = true
		remove_fog()


# --------------------------------------------------
# Registers enemies that will be spawned later
# (e.g. gorebits from a dying gorebyte).
# Call this BEFORE the spawner dies so the count
# never prematurely hits zero.
# --------------------------------------------------
func register_enemies(enemies: Array[EnemyBase]) -> void:
	for enemy in enemies:
		remaining_enemies += 1
		enemy.died.connect(_on_enemy_died)


# --------------------------------------------------
# Called whenever an enemy emits "enemy_died"
# --------------------------------------------------
func _on_enemy_died():
	remaining_enemies -= 1

	# When the last enemy dies
	if remaining_enemies <= 0:
		room_cleared = true
		remove_fog()


# --------------------------------------------------
# Removes the fog node safely
# --------------------------------------------------
func remove_fog():
	var fog_node = get_node_or_null("fog")

	if fog_node:
		fog_node.queue_free()


# --------------------------------------------------
# Saves this room's state (called by RoomManager)
# --------------------------------------------------
func save_state() -> Dictionary:
	var state: Dictionary = {}

	state["room_cleared"] = room_cleared
	state["enemy_positions"] = enemy_positions

	print("Room saved state:", state)
	return state


# --------------------------------------------------
# Loads this room's state (called by RoomManager)
# --------------------------------------------------
func load_state(state: Dictionary) -> void:
	if state.is_empty():
		return

	# Restore whether the room was cleared
	if state.has("room_cleared"):
		room_cleared = state["room_cleared"]

	# Restore saved enemy data if needed
	if state.has("enemy_positions"):
		enemy_positions = state["enemy_positions"]
		# TODO: Apply saved positions to enemies here

	# If the room was previously cleared,
	# remove fog immediately
	if room_cleared:
		remove_fog()

	print("Room loaded state:", state)
