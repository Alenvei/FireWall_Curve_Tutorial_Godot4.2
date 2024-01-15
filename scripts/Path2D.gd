@tool
extends Path2D

# Exported variable to control the smoothness of the curve
@export var smoothness : float = .17

# Variables to store points and tangents
var last_point 
var next_point
var start_tangent 
var end_tangent 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Function to smooth the curve
	curve_smooth()

func curve_smooth():
	# Iterate through each point in the curve
	for i in curve.get_point_count():
		var pos =  curve.get_point_position(i)
		print(i)
		
		# Set the last point to the current point if it's the first point in the curve
		if i == 0:
			last_point = curve.get_point_position(0)
		else:
			last_point = curve.get_point_position(i - 1)
			
		# Set the next point to the next point in the curve or Vector2.ZERO if it's the last point
		if i != curve.get_point_count() - 1:
			next_point = curve.get_point_position(i + 1)
		else:
			next_point = Vector2.ZERO
			
		# Calculate directions and tangents
		var last_dir = (pos - last_point)
		var next_dir = (next_point - pos)
		
		start_tangent = (last_dir + next_dir) * smoothness
		end_tangent = (next_dir + last_dir) * (-1) * smoothness
		
		# Set tangents for points that are not the first or last
		if i != 0 and i != curve.get_point_count() - 1:
			curve.set_point_in(i, end_tangent)
			curve.set_point_out(i, start_tangent)
