extends Area

signal picked_up

export(Array, Color) var cloth_colors
export(Array, Texture) var pieces

onready var sprite = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	if not pieces.empty():
		sprite.texture = pieces[randi() % len(pieces)]
	if not cloth_colors.empty():
		sprite.modulate = cloth_colors[randi() % len(cloth_colors)]

func _input_event(camera, event, position, normal, shape_idx):
	var clicked = event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed()
	if clicked:
		emit_signal("picked_up")
		print("you picked up a piece of clothes!")
		queue_free()
