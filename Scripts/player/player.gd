extends CharacterBody3D

@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")
@onready var player_mesh = get_node("Knight")

@export var gravity: float = 9.8
@export var jump_speed: float = 9.0
@export var walk_speed: float = 3.0
@export var run_speed: float = 9.0

#animation nodes names
var idle_anim: String = "Idle"
var walk_anim: String = "Walk"
var run_anim: String = "Run"
var jump_anim: String = "Jump"
var attack1_anim: String = "Attack1"
var death_anim: String = "Death"

#state Machine Conditions
var is_attacking: bool
var is_walking: bool
var is_running: bool
var is_dying: bool

#physics values
var target_rotation: float
var direction: Vector3
var horizontal_velocity: Vector3
var aim_turn: float
var movement: Vector3
var vertical_velocity: Vector3
var movement_speed: float
var angular_acceleration: float
var acceleration: float
var just_hit: bool
var health: int = 5

@onready var camroot_h = get_node("camroot/h")

func _ready():
	horizontal_velocity = Vector3.ZERO
	vertical_velocity = Vector3.ZERO
	direction = Vector3.BACK.rotated(Vector3.UP, camroot_h.global_transform.basis.get_euler().y)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_turn = - event.relative.x * 0.015
	if event.is_action_pressed("aim"):
		direction = camroot_h.global_transform.basis.z.normalized()
		# Store the desired rotation while aiming
		target_rotation = camroot_h.rotation.y

func _physics_process(delta):
	var on_floor = is_on_floor()
	if !is_dying:
		attack1()
		if !on_floor:
			vertical_velocity += Vector3.DOWN * gravity * 2 * delta
		else:
			vertical_velocity = Vector3.DOWN * gravity / 10
		if Input.is_action_pressed("jump") and (!is_attacking) and on_floor:
			vertical_velocity = Vector3.UP * jump_speed

		angular_acceleration = 10
		movement_speed = 0
		acceleration = 15

		if (attack1_anim in playback.get_current_node()):
			is_attacking = true
		else:
			is_attacking = false

		var h_rot = camroot_h.global_transform.basis.get_euler().y
		if (Input.is_action_pressed("forward") || Input.is_action_pressed("backward") || Input.is_action_pressed("left") || Input.is_action_pressed("right")):
			direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"), 0, Input.get_action_strength("forward") - Input.get_action_strength("backward"))
			direction = direction.rotated(Vector3.UP, h_rot).normalized()
			if Input.is_action_pressed("sprint") and (is_walking):
				movement_speed = run_speed
				is_running = true
			else:
				is_walking = true
				movement_speed = walk_speed
		else:
			is_walking = false
			is_running = false

		if Input.is_action_pressed("aim"):
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, target_rotation, delta * angular_acceleration)
		else:
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * angular_acceleration)

		if is_attacking:
			horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * 0.1, acceleration * delta)
		else:
			horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * movement_speed, acceleration * delta)

		velocity.z = horizontal_velocity.z + vertical_velocity.z
		velocity.x = horizontal_velocity.x + vertical_velocity.x
		velocity.y = vertical_velocity.y
		move_and_slide()
	animation_tree["parameters/conditions/IsOnFloor"] = on_floor
	animation_tree["parameters/conditions/IsInAir"] = !on_floor
	animation_tree["parameters/conditions/IsWalking"] = is_walking
	animation_tree["parameters/conditions/IsRunning"] = is_running
	animation_tree["parameters/conditions/IsNotWalking"] = !is_walking
	animation_tree["parameters/conditions/IsNotRunning"] = !is_running
	animation_tree["parameters/conditions/is_dying"] = is_dying

func attack1():
	if (idle_anim in playback.get_current_node()) or (walk_anim in playback.get_current_node()):
		if Input.is_action_just_pressed("attack"):
			if !is_attacking:
				playback.travel(attack1_anim)


func _on_damage_detector_body_entered(body:Node3D):
	if body.is_in_group("Monster") and is_attacking:
		body.hit(2)

func hit(damage: int):
	if !just_hit:
		just_hit = true
		get_node("just_hit").start()
		health -= damage
		if health < 0:
			is_dying = true
			playback.travel(death_anim)
		#knockback
		var tween = create_tween()
		tween.tween_property(self, "global_position", global_position - (direction/1.5), 0.2)


func _on_animation_tree_animation_finished(anim_name:StringName):
	if "Death" in anim_name:
		await get_tree().create_timer(1.0).timeout
		get_node("../gameover_overlay").game_over()


func _on_just_hit_timeout():
	just_hit = false
