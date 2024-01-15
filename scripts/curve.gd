extends Path3D

@export var smoothnes :float = .5

var lastpoint 
var nextpoint
var start_tangent 
var end_tangent 
var velocity :Vector3

func _process(delta):
	curve_smoothe()
	pass
	
func curve_smoothe():
	for i in curve.get_point_count():
		var pos =  curve.get_point_position(i)
		
		if i == 0:
			lastpoint = curve.get_point_position(0)
		else:
			lastpoint = curve.get_point_position(i - 1)
		if i != curve.get_point_count()-1:
			
			nextpoint = curve.get_point_position(i + 1)
		else:
			nextpoint = Vector3.ZERO
			
		var last_dir = (pos - lastpoint).normalized()
		var next_dir = (nextpoint - pos).normalized()
		
		start_tangent = (last_dir+next_dir ) *smoothnes
		end_tangent =(next_dir + last_dir) *(-1) *smoothnes
		
		if i!= 0 and i!= curve.get_point_count()-1:
			curve.set_point_in(i,end_tangent )
			curve.set_point_out(i,start_tangent )
		

func creating_points_on_curve(pos):
	curve.add_point(to_local(pos))
	
func move_last_point(pos, index):
	curve.set_point_position(index,to_local(pos))
	
