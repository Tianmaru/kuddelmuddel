extends Area


export(Array, Color) var shirt_colors

onready var sprite = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	if not shirt_colors.empty():
		sprite.modulate = shirt_colors[randi() % len(shirt_colors)]

func _on_Shirt_input_event(camera, event, position, normal, shape_idx):
	var clicked = event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed()
	if clicked:
		print("you picked up a shirt!")
		queue_free()
