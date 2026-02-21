class_name GorebitEnemy
extends EnemyBase

@export var attack_range: float = 30.0


func _ready() -> void:
	add_to_group("enemies")
