extends Area2D

@export var target_position: Vector2 = Vector2.ZERO
@export var target_scene: PackedScene

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var managers = get_tree().get_nodes_in_group("room_manager")
		if managers.size() > 0:
			var room_manager = managers[0]
			if target_scene == null:
				print("Warning: target_scene not set on door: ", self.name)
				return
			room_manager.change_room(target_position, target_scene)
		else:
			print("No RoomManager found in scene tree")
