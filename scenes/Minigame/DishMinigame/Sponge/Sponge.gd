extends Node2D

export(float) var SPEED = 100

signal cleaning_finished

var mouse_delta := Vector2()
var distance := 0.0
var angle := 0

onready var sprite = $Sprite

func _ready():
	distance = position.distance_to(sprite.position)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

func _process(delta):
	var velocity = mouse_delta * SPEED * delta
	var dir_vec = position.direction_to(sprite.position)
	var new_dir_vec = position.direction_to(sprite.position + velocity)
	var new_pos =  position + new_dir_vec * distance
	if dir_vec.angle_to(new_dir_vec) < 0 and angle < 360:
		var new_angle = fmod(rad2deg(atan2(-dir_vec.y, dir_vec.x)) + 270, 360)
		if new_angle < angle:
			angle = 360
			sprite.position
			emit_signal("cleaning_finished")
		else:
			angle = new_angle
			sprite.position = new_pos
	mouse_delta = Vector2()
