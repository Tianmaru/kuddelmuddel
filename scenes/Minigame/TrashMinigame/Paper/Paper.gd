extends RigidBody2D

signal clicked(object)

var held = false

var mouse_pos := Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input_event(viewport, event, shape_idx):
	var clicked = event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed
	# var touched = event is InputEventScreenTouch and event.is_pressed()
	if clicked:
		emit_signal("clicked", self)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		#mouse_pos = event.global_position #funktioniert weder normal, noch fullscreen, sind screen coordinaten, (0,0) ist oben links
		# mouse_pos = get_viewport().get_final_transform().affine_inverse() * event.position
		# mouse_pos =  get_viewport_transform().affine_inverse() * event.position # funktioniert in normal und fullscreen
		mouse_pos =  get_canvas_transform().affine_inverse() * event.position # funktioniert normal, aber nimmt kein scaling von fullscreen
		#mouse_pos =  get_viewport_transform().affine_inverse() * (get_canvas_transform().affine_inverse() * event.global_position) # funktioniert, aber um Kamera verschoben?
		#mouse_pos =  get_canvas_transform().affine_inverse() * (get_viewport_transform().affine_inverse() * event.global_position)
		print(mouse_pos)

func _integrate_forces(state):
	if held:
		#print( get_viewport_transform().affine_inverse() * get_viewport().get_mouse_position())
		#var mouse_pos = get_global_mouse_position()
		#mouse_pos *= get_viewport().size / OS.get_window_size()
		#mouse_pos = get_global_mouse_position()
		#mouse_pos = get_viewport().get_final_transform().xform()
		#print(get_global_transform().xform(get_viewport().get_mouse_position())
		#var mouse_pos = get_viewport().get_camera().project_position(get_viewport().get_mouse_position(), 1)
		#print("mouse pos: ", get_global_mouse_position())
		var force = mouse_pos - global_position 
		state.linear_velocity = force * state.step * 400

func pickup():
	if held:
		return
	#mode = RigidBody2D.MODE_KINEMATIC
	held = true
	custom_integrator = true
	mouse_pos = global_position

func drop(impulse=Vector2.ZERO):
	if held:
		#mode = RigidBody2D.MODE_RIGID
		held = false
		custom_integrator = false
		apply_central_impulse(impulse * 0.5)

func _on_can_entered():
	input_pickable = false
	remove_from_group("pickable")
