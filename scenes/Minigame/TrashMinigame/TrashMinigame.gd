class_name TrashMinigame
extends Minigame

var held_object = null

onready var spawn = $Spawn

var paper_scn = preload("res://scenes/Minigame/TrashMinigame/Paper/Paper.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(difficulty):
		var paper = paper_scn.instance()
		spawn.add_child(paper)
		paper.position.x += i * 150
	for node in get_tree().get_nodes_in_group("pickable"):
		print("connected")
		
		node.connect("clicked", self, "_on_pickable_clicked")

func _process(delta):
	if len(get_tree().get_nodes_in_group("pickable")) == 0:
		print("won")
		set_process(false)
		emit_signal("minigame_over")

func _unhandled_input(event):
	var unclicked = event is InputEventMouseButton and event.button_index == BUTTON_LEFT
	#var untouched = event is InputEventScreenTouch
	if unclicked:
		if not event.pressed and held_object:
			held_object.drop(Input.get_last_mouse_speed())
			held_object = null

func _on_pickable_clicked(object):
	if not held_object:
		held_object = object
		held_object.pickup()

func _on_TrashZone_body_entered(body):
	body.disconnect("clicked", self, "_on_pickable_clicked")
	body.drop()
	body.remove_from_group("pickable")
	body.set_deferred("input_pickable", false)
