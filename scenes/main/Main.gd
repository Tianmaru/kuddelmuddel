extends Spatial

export(int) var MAX_SHIRTS = 12
export(int) var SHIRTS_PER_CHAOS = 3
export(int) var MAX_CHAOS_PER_DAY = 10

var chaos_per_day = 3

var minigame : Minigame
var minigame_dishes = preload("res://scenes/Minigame/DishMinigame/DishMinigame.tscn")
var minigame_work = preload("res://scenes/Minigame/WorkMinigame/WorkMinigame.tscn")
var minigame_trash = preload("res://scenes/Minigame/TrashMinigame/TrashMinigame.tscn")
var minigame_source : ChaosObject

var shirt_scn = preload("res://scenes/shirt/Shirt.tscn")

onready var plants = $Plants
onready var books = $Books
onready var trashcan = $Trashcan
onready var paperwork = $Paperwork
onready var dishes = $Dishes
onready var minigame_overlay = $MinigameOverlay
onready var viewport = $MinigameOverlay/ViewportContainer/Viewport
onready var cloth_piles = $ClothPiles
onready var clock = $Clock
onready var anim = $AnimationPlayer
onready var day_label = $Transition/VBoxContainer/HBoxContainer/DayLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	day_label.text = str(clock.day)
	anim.play("show_day")

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		plants.set_chaos_level(plants.chaos_level + 1) 

func _on_Plants_clicked():
	plants.decrease_chaos()

func _on_Trashcan_clicked():
	minigame_source = trashcan
	start_minigame(minigame_trash)

func _on_Paperwork_clicked():
	minigame_source = paperwork
	start_minigame(minigame_work)

func _on_Dishes_clicked():
	minigame_source = dishes
	start_minigame(minigame_dishes)

func _on_Books_clicked():
	books.decrease_chaos()

func start_minigame(scn):
	if minigame:
		return
	minigame_overlay.visible = true
	minigame = scn.instance()
	minigame.difficulty = minigame_source.chaos_level
	viewport.add_child(minigame)
	minigame.connect("minigame_over", self, "_on_minigame_over")

func end_minigame():
	minigame_overlay.visible = false
	for child in viewport.get_children():
		child.queue_free()
	minigame = null
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_minigame_over():
	minigame_source.set_chaos_level(0)
	end_minigame()

func spawn_shirt():
	var pile = cloth_piles.get_children()[randi() % cloth_piles.get_child_count()]
	var shirt = shirt_scn.instance()
	shirt.rotate_y(randf() * 2 * PI)
	var scale = rand_range(0.8, 1.2)
	shirt.scale = shirt.scale * Vector3(scale, 1, scale)
	var offset = Vector3()
	offset.x = rand_range(-0.25, 0.25)
	offset.z = rand_range(-0.25, 0.25)
	shirt.transform.origin += offset
	pile.add_child(shirt)

func _on_Clock_end_of_day():
	clock.stop()
	end_minigame()
	clock.reset()
	anim.play("fade_out")
	day_label.text = str(clock.day)
	print("fade_out")

func next_day():
	print(chaos_per_day)
	for i in range(chaos_per_day):
		make_mess()
	chaos_per_day = min(chaos_per_day + 1, MAX_CHAOS_PER_DAY)
	anim.play("fade_in")

func make_mess():
	var chaos_objects = [books, plants, trashcan, dishes, paperwork]
	var tolerable_objects = []
	for x in chaos_objects:
		if x.chaos_level < 4:
			tolerable_objects.append(x)
	if tolerable_objects.empty() and not len(get_tree().get_nodes_in_group("shirt")) < MAX_SHIRTS:
		game_over()
	var mess_mode = 0
	if len(get_tree().get_nodes_in_group("shirt")) < MAX_SHIRTS:
		mess_mode = randi() % (len(chaos_objects) + 1)
	else:
		mess_mode = randi() % len(chaos_objects)
	if mess_mode < len(chaos_objects):
		chaos_objects[mess_mode].increase_chaos()
	else:
		for i in range(SHIRTS_PER_CHAOS):
			spawn_shirt()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		anim.play("show_day")
	elif anim_name == "show_day":
		next_day()
	elif anim_name == "fade_in":
		clock.start()

func game_over():
	get_tree().change_scene("res://scenes/Gameover/Gameover.tscn")
