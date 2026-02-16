extends Node2D

@export var player_path: NodePath
@export var first_room_scene: PackedScene

@onready var current_room: Node = null
@onready var game_state = get_node("/root/GameState")

func _ready():
	if first_room_scene != null:
		add_room(first_room_scene)
	else:
		print("No first room assigned!")

func add_room(new_scene: PackedScene):
	if new_scene != null:
		# Save old room state before deleting
		if current_room != null and is_instance_valid(current_room):
			var old_room_name = current_room.name
			if current_room.has_method("save_state"):
				var saved_state = current_room.save_state()
				game_state.save_room_state(old_room_name, saved_state)
			current_room.queue_free()

		# Instance new room
		current_room = new_scene.instantiate()
		add_child(current_room)

		# Load saved state for new room if exists
		var new_room_name = current_room.name
		if current_room.has_method("load_state"):
			var loaded_state = game_state.load_room_state(new_room_name)
			current_room.load_state(loaded_state)
	else:
		print("No scene provided to add_room()")

func change_room(new_player_pos: Vector2, new_scene: PackedScene):
	add_room(new_scene)

	if has_node(player_path):
		var player = get_node(player_path) as CharacterBody2D
		player.global_position = new_player_pos
	else:
		print("Player node not found at path:", player_path)
