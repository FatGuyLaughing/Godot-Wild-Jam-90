class_name VargazerEnemy
extends EnemyBase

@onready var laser_origin: Marker2D = %LaserOrigin
@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	add_to_group("enemies")
