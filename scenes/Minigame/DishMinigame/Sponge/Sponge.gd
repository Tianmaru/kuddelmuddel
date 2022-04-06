extends Node2D

export(float) var SPEED = 100

var mouse_delta := Vector2()
var distance := 0.0

onready var sponge = $Spongebob

func _ready():
	distance = position.distance_to(sponge.position)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
		print(mouse_delta)

func _physics_process(delta):
	var velocity = mouse_delta * SPEED
	print(velocity)
	sponge.move_and_slide(velocity)
	sponge.rotation = position.direction_to(sponge.position).angle()
	var clamped_pos = position.direction_to(sponge.position).normalized() * distance
	sponge.move_and_collide(clamped_pos - sponge.position)
	mouse_delta = Vector2()

#func _integrate_forces(state):
	#var force = mouse_delta * SPEED * state.step
	#state.linear_velocity = force
	#state.add_central_force(force)
	#mouse_delta = Vector2()
