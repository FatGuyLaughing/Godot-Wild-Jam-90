extends Node2D

@export var player_path: NodePath
@export var first_room_scene: PackedScene
@export var door_cooldown_time: float = 0.2  # Seconds to ignore rapid retriggers

var current_room: Node = null
var door_timer: float = 0.0
var _transitioning: bool = false


func _physics_process(delta: float) -> void:
	if door_timer > 0:
		door_timer -= delta

func _ready():
	if first_room_scene:
		add_room(first_room_scene)
	else:
		push_warning("No first_room_scene assigned!")

func add_room(new_scene: PackedScene, new_player_pos := Vector2.ZERO, reposition_player := false) -> void:
	if not new_scene:
		push_warning("No scene provided to add_room()")
		return

	_transitioning = true

	# Fade out and tear down the old room
	if current_room and is_instance_valid(current_room):
		await SceneTransition.fade_out()
		if current_room.has_method("save_state"):
			GameState.save_room_state(current_room.room_id, current_room.save_state())
		current_room.queue_free()

	# Instance new room
	current_room = new_scene.instantiate()
	add_child(current_room)
	print("Added room:", current_room.room_id)

	# Move the player before the scene is revealed
	if reposition_player:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.global_position = new_player_pos
			print("Player moved to:", player.global_position)
		else:
			push_warning("Player node not found at path: %s" % player_path)

	# Connect all doors in this room
	for door in current_room.get_children():
		if door.is_in_group("doors"):
			door.request_room_change.connect(_on_door_request_room_change)
			print("Connected door:", door.name, "in room:", current_room.room_id)

	# Load saved state
	if current_room.has_method("load_state"):
		current_room.load_state(GameState.load_room_state(current_room.room_id))

	# Reveal the new room
	await SceneTransition.fade_in()
	_transitioning = false

func _on_door_request_room_change(new_position: Vector2, target_scene: PackedScene) -> void:
	if _transitioning or door_timer > 0:
		print("Door cooldown active, ignoring rapid trigger")
		return

	door_timer = door_cooldown_time

	print("Room change requested from room:", current_room.room_id, "to scene:", target_scene, "player pos:", new_position)

	if target_scene == null:
		push_warning("Door requested a room change but target_scene is null")
		return

	add_room(target_scene, new_position, true)

func change_room(new_player_pos: Vector2, new_scene: PackedScene) -> void:
	print("Changing room to:", new_scene, "with player position:", new_player_pos)
	add_room(new_scene, new_player_pos, true)
