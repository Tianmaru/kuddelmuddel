extends Minigame

const SPEED = 100
const drag = 0.01

var mouse_delta = Vector2()
var active_doc
var document_scn = preload("res://scenes/Minigame/WorkMinigame/Document/Document.tscn")
var documents = []

onready var documents_node = $Documents
onready var camera = $Camera2D
onready var penalty_timer = $PenaltyTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for i in range(2 * difficulty):
		var doc = document_scn.instance()
		documents_node.add_child(doc)
		if randi() % 2 == 0:
			doc.approved = true
		else:
			doc.approved = false
	documents = documents_node.get_children()
	get_next_doc()

func _unhandled_input(event):
	# var unclicked = event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed()
	#var untouched = event is InputEventScreenTouch and not event.is_pressed()
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

func _physics_process(delta):
	if active_doc:
		active_doc.position.x += mouse_delta.x * delta * SPEED
		active_doc.position.x = clamp(active_doc.position.x, -400, 400)
		mouse_delta *= pow(drag, delta)

func _on_ApprovedArea_area_entered(area):
	next_doc(active_doc.approved)

func _on_RejectedArea_area_entered(area):
	next_doc(not active_doc.approved)

func next_doc(was_correct):
	if was_correct:
		active_doc.queue_free()
		active_doc = null
		if len(documents) == 0:
			emit_signal("minigame_over")
			set_process(false)
		else:
			get_next_doc()
	else:
		camera.shake()
		active_doc.position = documents_node.position
		mouse_delta = Vector2()
		set_physics_process(false)
		penalty_timer.start()

func get_next_doc():
	active_doc = documents.pop_back()
	mouse_delta = Vector2()

func _on_PenaltyTimer_timeout():
	set_physics_process(true)
	mouse_delta = Vector2()
