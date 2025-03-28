extends Node3D

@export var cam_v_max: int = 75
@export var cam_v_min: int = -55
var camroot_h: float = 0
var camroot_v: float = 0
var h_sensitivity: float = 0.01
var v_sensitivity: float = 0.01
var h_acceleration: float = 10.0
var v_acceleration: float = 10.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camroot_h += -event.relative.x * h_sensitivity
		camroot_v += event.relative.y * v_sensitivity

func _physics_process(delta):
	camroot_v = clamp(camroot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
	get_node("h").rotation.y = lerpf(get_node("h").rotation.y, camroot_h, h_acceleration * delta)
	get_node("h/v").rotation.x = lerpf(get_node("h/v").rotation.x, camroot_v, v_acceleration * delta)
