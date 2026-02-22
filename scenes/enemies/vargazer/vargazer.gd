class_name VargazerEnemy
extends EnemyBase

var aggro: bool = false

@onready var laser_origin: Marker2D = %LaserOrigin
#@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	super._ready()
	_health.health_changed.connect(_on_health_changed)


func _on_health_changed(_old_value: float, _new_value: float) -> void:
	aggro = true
