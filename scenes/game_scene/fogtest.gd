extends Area2D

var activated = false
var fogact = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not activated and not fogact:
		activated = true

		var fog_node = get_node_or_null("../fog")
		if fog_node:
			fog_node.queue_free()
