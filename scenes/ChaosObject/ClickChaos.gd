class_name ClickChaos
extends ChaosObject

const HOVER_GROW = 0.1

onready var area = $Area
onready var mesh_root = $Meshes

# var outline = preload("res://scenes/ChaosObject/Outline3D.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_chaos_level(chaos_level)

func hide_all():
	for child in mesh_root.get_children():
		child.hide()

func _set_chaos_level(value : int):
	if not mesh_root or not area:
		return
	hide_all()
	mesh_root.get_child(value).show()
	if chaos_level == 0:
		area.input_ray_pickable = false
	elif chaos_level > 0:
		area.input_ray_pickable = true

func _on_Area_input_event(camera, event, position, normal, shape_idx):
	var clicked = event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed()
	if clicked and chaos_level > 0:
		print(name, "clicked")
		emit_signal("activated")

func set_materials(material):
	for mesh in mesh_root.get_children():
		for i in mesh.get_surface_material_count():
			mesh.get_active_material(i).next_pass = material

func set_scales(scale):
	for mesh in mesh_root.get_children():
		mesh.scale = scale

func _on_Area_mouse_entered():
	print("hover")
	set_scales(Vector3(1 + HOVER_GROW, 1 + HOVER_GROW, 1 + HOVER_GROW))
	#set_materials(outline)

func _on_Area_mouse_exited():
	print("unhover")
	set_scales(Vector3(1,1,1))
	#set_materials(null)
