class_name VargazerRangedAttackState
extends State

enum Substate { WAIT, TRACK, LOCK, FIRE, COOLDOWN }

## How long the laser tracks the player
@export var tracking_duration: float = 2
## How long the laser stops tracking before firing
@export var locking_duration: float = 1
## How long the laser's hitbox is active
@export var firing_duration: float = 1
## How long after firing before can fire again
@export var cooldown_duration: float = 3
## Laser target offset
@export var target_offset: Vector2 = Vector2(0, -32)
@export var laser_telegraph_size: float = 6
@export var laser_fire_size: float = 36


var substate: Substate = Substate.WAIT
var laser_scene: PackedScene = load("res://components/laser/laser.tscn")
var countdown: float = 0
var in_cooldown: bool = false

var laser: Laser


func can_attack() -> bool:
	return substate == Substate.WAIT


func valid_target() -> bool:
	return entity.player_in_sight and entity.player_in_range


func enter() -> void:
	print("Vargazer state RangedAttack")
	if substate != Substate.COOLDOWN:
		substate = Substate.WAIT
	entity.animation_player.play("attack")


func exit() -> void:
	if is_instance_valid(laser):
		laser.target = Vector2.ZERO
		laser.disable_hitbox()
		laser.queue_free()


# we want cooldown to progress even if this state is not active
func _physics_process(delta: float) -> void:
	if substate == Substate.COOLDOWN:
		countdown -= delta
		if countdown <= 0:
			substate = Substate.WAIT


func physics_process(delta: float) -> void:
	match substate:
		Substate.WAIT:
			#entity.label.text = "Wait"
			process_wait(delta)
		Substate.TRACK:
			#entity.label.text = "Track"
			process_track(delta)
		Substate.LOCK:
			#entity.label.text = "Lock"
			process_lock(delta)
		Substate.FIRE:
			#entity.label.text = "Fire"
			laser.enable_hitbox()
			process_fire(delta)
		Substate.COOLDOWN:
			#entity.label.text = "Cooldown"
			pass


func process_wait(_delta: float) -> void:
	if valid_target:
		# enter track state
		countdown = tracking_duration
		laser = laser_scene.instantiate()
		laser.width = laser_telegraph_size
		entity.laser_origin.add_child(laser)
		_update_laser_target()
		substate = Substate.TRACK
	else:
		transition_to("Idle")


func process_track(delta: float) -> void:
	if not valid_target:
		transition_to("Idle")
	countdown -= delta
	if countdown <= 0:
		# enter lock state
		countdown = locking_duration
		substate = Substate.LOCK
	_update_laser_target()


func process_lock(delta: float) -> void:
	countdown -= delta
	if countdown <= 0:
		# enter fire state
		countdown = firing_duration
		laser.width = laser_fire_size
		laser.enable_hitbox()
		substate = Substate.FIRE


func process_fire(delta: float) -> void:
	countdown -= delta
	if countdown <= 0:
		# enter cooldown state
		laser.disable_hitbox()
		laser.queue_free()
		countdown = cooldown_duration
		substate = Substate.COOLDOWN


func _update_laser_target() -> void:
	laser.target = entity.player_ref.global_position + target_offset
