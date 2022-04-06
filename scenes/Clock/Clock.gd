extends Spatial

signal end_of_day

export(int) var HOURS_PER_DAY = 10
export(bool) var autostart = false

var time = 0
var day = 1

onready var hand = $Hand
onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	if autostart:
		start()

func start():
	timer.start()

func stop():
	timer.stop()

func reset():
	hand.rotation.x = 0

func _on_Timer_timeout():
	hand.rotate_x(-2 * PI / HOURS_PER_DAY)
	time += 1
	if time == HOURS_PER_DAY:
		time = 0
		day += 1
		print(name, ": end of day!")
		emit_signal("end_of_day")

