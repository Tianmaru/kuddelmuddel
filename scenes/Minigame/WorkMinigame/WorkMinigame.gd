extends Minigame

const SPEED = 100
const drag = 0.9

var mouse_delta = Vector2()
var active_doc
var document_scn = preload("res://scenes/Minigame/WorkMinigame/Document/Document.tscn")
var documents = []

onready var documents_node = $Documents

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

func _input(event):
	var unclicked = event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed()
	var untouched = event is InputEventScreenTouch and not event.is_pressed()
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		mouse_delta = event.relative

func _process(delta):
	if active_doc:
		active_doc.position.x += mouse_delta.x * delta * SPEED
		mouse_delta *= drag

func _on_ApprovedArea_area_entered(area):
	next_doc(active_doc.approved)

func _on_RejectedArea_area_entered(area):
	next_doc(not active_doc.approved)

func next_doc(was_correct):
	if was_correct:
		active_doc.queue_free()
		if len(documents) == 0:
			emit_signal("minigame_over")
			set_process(false)
		else:
			get_next_doc()
	else:
		active_doc.position = documents_node.position

func get_next_doc():
	active_doc = documents.pop_back()
	mouse_delta = Vector2()
