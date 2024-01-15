extends CharacterBody3D

@export var SPEED = 5.0
@export var look_sensitivity : float = 0.001 / 1.5
@export var max_distance : float 
@export var point_per_distance : float = 0.2
@onready var path_3d = $"../Path3D"
@onready var animation_player = $"../AnimationPlayer"
var boolean : bool = false
var points_distance : float  = point_per_distance
var old_position : Vector3
var total_distance : float
var index : int = 0

func _input(event):
	# Mouse motion input handling for Y rotation of the controller.
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)

func _physics_process(delta):
	# Calculate velocity and distance traveled
	velocity = -SPEED * global_transform.basis.z
	var traveled_distance = position - old_position
	var distance_this_frame = traveled_distance.length()
	
	# Accumulate total distance
	total_distance += distance_this_frame
	old_position = position
	
	# Check if the total distance is within the specified maximum distance
	if total_distance < max_distance:
		move_and_slide()
		
		# Move the last point in the path_3d if the index is greater than 1
		if index > 1:
			path_3d.move_last_point(position, index - 1)
		
		# Add points to the path_3d at specified distances
		if total_distance > points_distance:
			path_3d.creating_points_on_curve(position)
			
			points_distance = total_distance + point_per_distance
			index = index + 1 
	else:
		# Trigger animation and timer when the total distance exceeds the maximum distance
		if !boolean:
			$"../Timer".start()
			animation_player.play("fire_wall")
			boolean = true

func _on_timer_timeout():
	# Play the animation backward, hide and disable collision for the fire_wall path_3d
	animation_player.play_backwards("fire_wall")
	
	await animation_player.animation_finished
	
	$"../Path3D/fire_wall".visible = false
	$"../Path3D/fire_wall".use_collision = false
	
	# Play the fire_path animation
	animation_player.play("fire_path")
	
	await animation_player.animation_finished
	
	# Queue-free the parent node when all animations are finished
	get_parent().queue_free()
