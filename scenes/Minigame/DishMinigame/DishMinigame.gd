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
	set_process(false)
	for i in range(difficulty):
		var plate = plate_scn.instance()
		plates_node.add_child(plate)
		plate.position = spawn.position + i * OFFSET
	plates = plates_node.get_children()
	next_plate()

func _process(delta):
	if active_plate and sponge:
		active_plate.clean(sponge.angle)

func next_plate():
	if active_plate:
		if sponge:
			sponge.disconnect("cleaning_finished", self, "_on_plate_cleaned")
			sponge.queue_free()
			sponge = null
		active_plate.move_to(exit.position - i_plate * OFFSET, DURATION)
		i_plate += 1
		if len(plates) == 0:
			yield(active_plate, "moved")
			emit_signal("minigame_over")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			return
	active_plate = plates.pop_back()
	active_plate.move_to(cleaning.position, DURATION)
	yield(active_plate, "moved")
	start_cleaning()

func start_cleaning():
	sponge = sponge_scn.instance()
	add_child(sponge)
	sponge.connect("cleaning_finished", self, "_on_plate_cleaned")
	set_process(true)

func _on_plate_cleaned():
	set_process(false)
	active_plate.set_cleaned()
	next_plate()
