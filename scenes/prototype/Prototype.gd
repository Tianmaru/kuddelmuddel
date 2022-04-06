extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shirt_scn = preload("res://scenes/shirt/Shirt.tscn")

const SHIRT_COLORS = [Color.blue, Color.red, Color.green]
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(10):
		var shirt = shirt_scn.instance()
		add_child(shirt)
		shirt.rotate_y(randf() * 360)
		shirt.translate(Vector3(rand_range(-1,1),0, rand_range(-1,1)))
		shirt.get_node("Sprite3D").modulate = SHIRT_COLORS[randi() % len(SHIRT_COLORS)]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
