extends Minigame

const MOVE_SPEED = 100
const DISTANCE = 100
const DURATION = 0.25
const OFFSET = Vector2(32, 0)

onready var spawn = $Spawn
onready var cleaning = $Cleaning
onready var exit = $Exit
onready var plates_node = $Plates

var plate_scn = preload("res://scenes/Minigame/DishMinigame/Plate/Plate.tscn")
var sponge_scn = preload("res://scenes/Minigame/DishMinigame/Sponge/Sponge.tscn")

var sponge
var active_plate : Plate
var plates = []
var i_plate = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for i in range(difficulty):
		var plate = plate_scn.instance()
		plates_node.add_child(plate)
		plate.position = spawn.position + i * OFFSET
		plate.set_cleaning(false)
	plates = plates_node.get_children()
	next_plate()

func next_plate():
	if active_plate:
		active_plate.set_cleaning(false)
		if sponge:
			sponge.queue_free()
		active_plate.disconnect("cleaned", self, "_on_plate_cleaned")
		active_plate.move_to(exit.position - i_plate * OFFSET, DURATION)
		i_plate += 1
		if len(plates) == 0:
			yield(active_plate, "moved")
			emit_signal("minigame_over")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			return
	active_plate = plates.pop_back()
	active_plate.connect("cleaned", self, "_on_plate_cleaned")
	active_plate.move_to(cleaning.position, DURATION)
	yield(active_plate, "moved")
	start_cleaning()

func start_cleaning():
	active_plate.set_cleaning(true)
	sponge = sponge_scn.instance()
	add_child(sponge)

func _on_plate_cleaned():
	next_plate()
