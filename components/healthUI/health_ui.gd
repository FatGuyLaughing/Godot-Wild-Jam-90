## Displays health using a single heart sprite strip.
## The heart fills or empties based on the health percentage.
## Set [member target_type] in the inspector to wire up automatically.
extends Control

enum TargetType { PLAYER, BOSS }

## The full heart sprite strip texture (all states arranged horizontally).
@export var heart_texture: Texture2D

## Total number of heart states in the sprite strip.
@export var total_states: int = 10

## Which entity this health UI tracks.
@export var target_type: TargetType = TargetType.PLAYER

## Maximum health value.
var max_health: float = 100.0

## Current health value.
var current_health: float = 100.0

@onready var heart: TextureRect = $Heart

var frame_width: int
var frame_height: int
var atlas: AtlasTexture = AtlasTexture.new()

var _health_component: HealthComponent


func _ready() -> void:
	frame_width = heart_texture.get_width() / total_states
	frame_height = heart_texture.get_height()

	atlas.atlas = heart_texture
	heart.texture = atlas

	# Defer binding so other nodes have finished _ready() and joined groups
	_bind_target.call_deferred()
	update_heart()


func _bind_target() -> void:
	match target_type:
		TargetType.PLAYER:
			var player = get_tree().get_first_node_in_group("player") as PlayerCharacter
			if player:
				_connect_health(player._health)
			else:
				push_warning("HealthUI: Player not found in group 'player'")
		TargetType.BOSS:
			var boss = get_tree().get_first_node_in_group("boss") as GorebyteEnemy
			if boss:
				_connect_health(boss._health)
				boss.died.connect(_on_target_died)
			else:
				push_warning("HealthUI: Boss not found in group 'boss'")


func _connect_health(health: HealthComponent) -> void:
	_health_component = health
	max_health = health.max_health
	current_health = health.get_current_health()
	health.health_changed.connect(_on_health_changed)


func _on_health_changed(_old_value: float, new_value: float) -> void:
	set_health(new_value)


func _on_target_died() -> void:
	set_health(0.0)


## Sets the maximum health value.
func set_max_health(value: float) -> void:
	max_health = value


## Updates the current health and refreshes the heart display.
func set_health(value: float) -> void:
	current_health = clampf(value, 0.0, max_health)
	update_heart()


## Calculates the correct heart frame based on health percentage
## and updates the displayed region of the sprite strip.
func update_heart() -> void:
	if max_health <= 0.0:
		return

	var percent: float = current_health / max_health

	# Reverse the frame index because leftmost frame is full heart
	var frame_index: int = clampi(
		int((1.0 - percent) * (total_states - 1)),
		0,
		total_states - 1
	)

	atlas.region = Rect2(
		frame_index * frame_width,
		0.0,
		frame_width,
		frame_height
	)
