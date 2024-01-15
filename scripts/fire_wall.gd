extends Node
# Exported variable for the fire_wall scene
@export var fire_wall : PackedScene

# Called when the node enters the scene tree for the first time.
func _input(event):
	# Check if the "place" action is pressed
	if event.is_action_pressed("place"):
		# Instantiate the fire_wall scene
		var wall_of_fire = fire_wall.instantiate()
		
		# Check if the instantiation was successful
		if wall_of_fire:
			# Set the initial position and add to the parent node
			wall_of_fire.position.z = -1
			get_parent().add_child(wall_of_fire)
			
			# Set as a top-level node and adjust the position
			wall_of_fire.set_as_top_level(true)
			wall_of_fire.position.y = 0
