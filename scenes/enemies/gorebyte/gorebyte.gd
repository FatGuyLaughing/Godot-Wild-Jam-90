class_name GorebyteEnemy
extends EnemyBase

@export var attack_range: float = 30.0
@export var is_boss: bool = false


func _ready() -> void:
	super._ready()
	if is_boss:
		scale = Vector2(2, 2)
		add_to_group("boss")
