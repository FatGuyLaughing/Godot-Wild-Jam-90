## Displays the player's health using a single heart sprite strip.
## The heart fills or empties based on the health percentage.
extends Control

## The full heart sprite strip texture (all states arranged horizontally).
@export var heart_texture: Texture2D

## Total number of heart states in the sprite strip.
@export var total_states: int = 10

## Maximum health value (set by Player on initialization).
var max_health: float = 100.0

## Current health value (updated dynamically).
var current_health: float = 100.0

@onready var heart: TextureRect = $Heart

var frame_width: int
var frame_height: int
var atlas: AtlasTexture = AtlasTexture.new()


func _ready() -> void:
	# Calculate the size of each frame in the sprite strip.
	frame_width = heart_texture.get_width() / total_states
	frame_height = heart_texture.get_height()

	# Assign the texture atlas once.
	atlas.atlas = heart_texture
	heart.texture = atlas

	update_heart()


## Sets the maximum health value (called by Player on start).
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
