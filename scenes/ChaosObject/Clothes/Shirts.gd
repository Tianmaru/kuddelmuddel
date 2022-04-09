extends ChaosObject

export(float) var SCALE_DEVIATION = 0.2
export(float) var OFFSET_DEVIATION = 0.25

var shirt_scn = preload("res://scenes/ChaosObject/Clothes/Clothing/Clothing.tscn")

onready var piles = $Piles

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _set_chaos_level(value: int):
	while len(get_tree().get_nodes_in_group("shirt")) < chaos_level:
		spawn_shirt()
	while len(get_tree().get_nodes_in_group("shirt")) > chaos_level:
		get_tree().get_nodes_in_group("shirt").back().queue_free()

func spawn_shirt():
	var pile = piles.get_children()[randi() % piles.get_child_count()]
	var shirt = shirt_scn.instance()
	shirt.rotate_y(randf() * 2 * PI)
	var scale = rand_range(1 - SCALE_DEVIATION, 1 + SCALE_DEVIATION)
	shirt.scale = shirt.scale * Vector3(scale, 1, scale)
	var offset = Vector3()
	offset.x = rand_range(-OFFSET_DEVIATION, OFFSET_DEVIATION)
	offset.z = rand_range(-OFFSET_DEVIATION, OFFSET_DEVIATION)
	shirt.transform.origin += offset
	pile.add_child(shirt)
	shirt.connect("picked_up", self, "_on_shirt_picked_up")

func _on_shirt_picked_up():
	chaos_level = max(0, chaos_level - 1)
