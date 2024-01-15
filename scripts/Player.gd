extends CharacterBody3D

@export var speed : float = 6.0
@export var jump_velocity : float = 8.0

var look_sensitivity : float = 0.001
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") *2
var velocity_y : float = 0
var update : bool = false
var gt_prev : Transform3D
var gt_current : Transform3D
var mesh_gt_prev : Transform3D
var mesh_gt_current : Transform3D

@onready var camera : Camera3D = $Camera3D
@onready var head : Node3D = $Head
@onready var pivot : Node3D = $Head/Pivot

func _ready():
	camera_setup()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		head.rotate_x(-event.relative.y * look_sensitivity)
		head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)

func _process(delta):
	if update:
		update_transform()
		update = false
	var f = clamp(Engine.get_physics_interpolation_fraction(), 0 ,1)
	camera.global_transform = gt_prev.interpolate_with(gt_current,f)

	pass
	
func _physics_process(delta):
	update = true
	var horizontal_velocity = Input.get_vector("left","right","forward","backward").normalized() * speed
	velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	
	if is_on_floor():
		velocity_y = jump_velocity if Input.is_action_just_pressed("jump") else 0
	else: velocity_y -= gravity * delta
	
	velocity.y = velocity_y
	move_and_slide()

	
func camera_setup():
	camera.set_as_top_level(true)
	camera.global_transform = pivot.global_transform
	gt_prev = pivot.global_transform
	gt_current = pivot.global_transform
	
func update_transform():
	gt_prev = gt_current
	gt_current = pivot.global_transform
	pass

func _on_area_3d_body_entered(body):
	if body.name == "fire_wall":
		$AnimationPlayer.play("ouch")
	pass 


func _on_area_3d_body_exited(body):
	if body.name == "fire_wall":
		$AnimationPlayer.play_backwards("ouch")
	pass 
