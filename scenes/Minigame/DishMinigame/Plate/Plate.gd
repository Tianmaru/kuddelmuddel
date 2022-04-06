class_name Plate
extends Node2D

signal cleaned
signal moved


onready var dirt = $DirtSprite
onready var tween = $Tween

onready var dirt_start = $StartDirtBody
onready var dirt_end = $EndDirtBody

func _process(delta):
	dirt.material.set_shader_param("cutoff_start", -dirt_start.rotation_degrees)
	dirt.material.set_shader_param("cutoff_end", -dirt_end.rotation_degrees)

func move_to(pos: Vector2, duration: float):
	tween.interpolate_property(self, "position", position, pos, duration)
	tween.start()

func set_cleaning(cleaning : bool):
	dirt_start.set_enabled(cleaning)
	dirt_end.set_enabled(cleaning)

func _on_Tween_tween_completed(object, key):
	print("moved")
	emit_signal("moved")

func _on_StartDirtBody_overlap():
	print(name, ": Clean!")
	dirt.visible = false
	emit_signal("cleaned")
