extends Area2D

signal request_room_change(new_position: Vector2, target_scene: PackedScene)

@export var target_position: Vector2 = Vector2.ZERO
@export var target_room_path: String = ""  # Path to target room scene

var target_room_scene: PackedScene = null

func _ready():
	# Load the target scene at runtime
	if target_room_path != "":
		target_room_scene = load(target_room_path)
	body_entered.connect(self._on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return

	print("Door triggered:", name, "target_scene:", target_room_scene, "target_position:", target_position)

	if target_room_scene == null:
		push_warning("Door '%s' has no valid target_room_scene!" % name)
		return

	emit_signal("request_room_change", target_position, target_room_scene)
