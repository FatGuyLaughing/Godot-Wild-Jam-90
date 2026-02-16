extends CharacterBody2D

# Export variables for easy adjustment in the Inspector
@export var speed : float = 300.0
@onready var detector = $Area2D
signal entrandopuerta

func _ready() -> void:
	add_to_group("player")
	# Detect PhysicsBodies
	detector.body_entered.connect(_on_body_entered)
	# Detect other Area2D
	detector.area_entered.connect(_on_area_entered)

func _on_body_entered(body):
	print("Player overlapped body:", body)

func _on_area_entered(area):
	print("Player overlapped area:", area)
	emit_signal("entrandopuerta")

func _physics_process(delta):
	# Get player input direction
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	var direction = Vector2(direction_x, direction_y).normalized()
	
	# Apply movement if there is input
	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	# Move the character and handle collisions
	move_and_slide()
