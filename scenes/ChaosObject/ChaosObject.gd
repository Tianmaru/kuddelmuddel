class_name ChaosObject
extends Area

signal clicked

const MAX_CHAOS = 4

export(int) var chaos_level = 0 setget set_chaos_level

export(Array, String, FILE, "*.mesh") var meshes

onready var mesh_instance = $MeshInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	set_chaos_level(chaos_level)

func _input_event(camera, event, position, normal, shape_idx):
	var clicked = event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed()
	if clicked and chaos_level > 0:
		emit_signal("clicked")

func set_chaos_level(value: int):
	chaos_level = clamp(value, 0, MAX_CHAOS)
	if mesh_instance and chaos_level < len(meshes):
		mesh_instance.mesh = load(meshes[chaos_level])
	if chaos_level == 0:
		input_ray_pickable = false
	elif chaos_level > 0:
		input_ray_pickable = true

func increase_chaos():
	set_chaos_level(chaos_level + 1)

func decrease_chaos():
	set_chaos_level(chaos_level - 1)
