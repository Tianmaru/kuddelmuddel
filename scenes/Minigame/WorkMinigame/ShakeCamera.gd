extends Camera2D

export(float) var MAX_TRAUMA := 50
export(float) var FREQUENCY := 10
var trauma := 0
var drag := 0.5
onready var origin := position

onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if not timer.is_stopped():
		trauma = lerp(0, MAX_TRAUMA, timer.time_left)
		var t = OS.get_ticks_msec() / 1000.0
		position.y = origin.y + trauma * sin(FREQUENCY * t * 2 * PI)
		#trauma *= pow(drag, delta)

func shake():
	timer.start()

func _on_Timer_timeout():
	trauma = 0
	position.y = origin.y
