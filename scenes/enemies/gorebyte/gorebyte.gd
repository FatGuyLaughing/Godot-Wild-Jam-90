class_name GorebyteEnemy
extends EnemyBase

@export var attack_range: float = 30.0

signal enemy_died

func _ready() -> void:
	add_to_group("enemies")
