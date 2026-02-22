## The playable character. Wires up combat components and handles
## global state transitions (hurt, death) that can occur in any state.
## Individual states handle input, movement, and animations.
class_name PlayerCharacter
extends CharacterBody2D

## Emitted when the player dies. The level or room manager
## should connect to this to handle game over.
signal died()

# We declare health_ui here but initialize it in _ready()
var health_ui: Control = null

@onready var _sprite: Sprite2D = %Body
@onready var _hurtbox: HurtboxComponent = %HurtboxComponent
@onready var _hitbox: HitboxComponent = %HitboxComponent
@onready var _health: HealthComponent = %HealthComponent
@onready var _state_machine: StateMachine = %StateMachine


func _ready() -> void:
	add_to_group("player")

	# Connect signals
	_health.health_changed.connect(_on_health_changed)
	_health.died.connect(_on_died)
	_hitbox.hit.connect(_on_hitbox_hit)

	# Find and setup health UI
	health_ui = get_health_ui()
	if health_ui:
		health_ui.set_max_health(_health.max_health)
		health_ui.set_health(_health.get_current_health())
	else:
		push_warning("HealthUI node not found!")

	_hitbox.enabled = false


func _process(_delta: float) -> void:
	_face_mouse()


## Flips the sprite horizontally so the player always faces the mouse.
## Runs every frame regardless of state to support kiting while attacking.
func _face_mouse() -> void:
	_sprite.flip_h = get_global_mouse_position().x < global_position.x


## Heals the player when the hitbox connects with an enemy.
func _on_hitbox_hit(_hurtbox: HurtboxComponent) -> void:
	_health.heal(2.0)


## Forces transition to Dead state and emits died signal.
func _on_died() -> void:
	_state_machine.transition_to("Dead")
	died.emit()


## Updates the UI whenever health changes.
func _on_health_changed(old_value: float, new_value: float) -> void:
	if health_ui != null:
		print("Health changed to: ", new_value)   # DEBUG
		health_ui.set_health(new_value)


## Helper function to find HealthUI node in the scene tree.
## Adjust the node path inside this function if your UI node is elsewhere.
func get_health_ui() -> Control:
	var root = get_tree().get_current_scene()

	# Example path if HealthUI is under CanvasLayer:
	if root.has_node("res://components/healthUI/health_ui.tscn"):
		return root.get_node("res://components/healthUI/health_ui.tscn")

	# Try root-level HealthUI node as fallback:
	if root.has_node("HealthUI"):
		return root.get_node("HealthUI")

	# Add other fallback paths here if needed

	return null
