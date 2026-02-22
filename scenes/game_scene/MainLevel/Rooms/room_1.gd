extends Node2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("Player entered area!")


func _on_door_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
