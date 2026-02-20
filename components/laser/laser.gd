class_name Laser extends Line2D

@export var color: Color = Color("ff00ff"):
	set(v):
		color = v
		_update_texture()
@export var target: Vector2 = Vector2.ZERO:
	set(v):
		target = v
		if not is_inside_tree():
			await ready
		#prints(target, position.angle_to_point(target))
		rotation = global_position.angle_to_point(target)
		var distance = global_position.distance_to(target)
		set_point_position(1, Vector2(distance, 0))

@onready var _collision_shape_2d: CollisionShape2D = $HitboxComponent/CollisionShape2D
@onready var _hitbox: HitboxComponent = $HitboxComponent


func enable_hitbox() -> void:
	_hitbox.enabled = true


func disable_hitbox() -> void:
	_hitbox.enabled = false


func reset() -> void:
	disable_hitbox()
	set_points([Vector2.ZERO, Vector2.ZERO])


func _ready() -> void:
	reset()


func _process(_delta: float) -> void:
	var distance: float = get_point_position(1).x
	_collision_shape_2d.shape.size = Vector2(distance, width / 2.0)
	_collision_shape_2d.position = Vector2(distance / 2.0, 0)


func _update_texture() -> void:
	# https://www.reddit.com/r/godot/comments/telp85/how_to_create_a_gradient_via_script/
	var data: Dictionary[float, Color] = {
		0.0: Color(color, 0),
		0.4: color,
		0.5: Color.WHITE,
		0.6: color,
		1.0: Color(color, 0),
	}
	var grad: Gradient = Gradient.new()
	grad.offsets = data.keys()
	grad.colors = data.values()

	var grad_texture: GradientTexture2D = GradientTexture2D.new()
	grad_texture.gradient = grad
	grad_texture.width = 32
	grad_texture.height = 32
	grad_texture.fill_from = Vector2(0.5, 0)
	grad_texture.fill_to = Vector2(0.5, 1)

	texture = grad_texture
