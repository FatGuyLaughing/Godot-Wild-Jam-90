extends Node2D
@export var old_node: PackedScene
@export var new_scene_path: String


func replace_node(old_node: Node, new_scene_path: String):
	# 1. Get a reference to the parent node
	var parent = old_node.get_parent()
	if parent == null:
		print("Cannot replace root node at runtime this way.")
		return

	# 2. Store properties you want to keep (e.g., position, name)
	var new_node_position = old_node.position if "position" in old_node else Vector2.ZERO
	var new_node_name = old_node.name

	# 3. Remove the old node from the scene tree
	parent.remove_child(old_node)

	# 4. Free the old node from memory (call_deferred is safer)
	old_node.queue_free() # The node is not freed immediately, some code might still use it

	# 5. Load and instantiate the new scene/node
	var new_scene = load(new_scene_path)
	var new_node = new_scene.instantiate()

	# 6. Add the new node to the tree under the same parent
	parent.add_child(new_node)

	# 7. Restore properties to the new node
	if "position" in new_node:
		new_node.position = new_node_position
	new_node.name = new_node_name

	# Optional: move it to the same order within children
	# parent.move_child(new_node, old_node_original_index)
