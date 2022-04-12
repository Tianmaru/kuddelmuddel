class_name Plate
extends Node2D

signal cleaned
signal moved


onready var dirt = $DirtSprite
onready var tween = $Tween

func clean(angle):
	dirt.material.set_shader_param("cutoff_start", angle)

func move_to(pos: Vector2, duration: float):
	tween.interpolate_property(self, "position", position, pos, duration)
	tween.start()

func _on_Tween_tween_completed(object, key):
	print("moved")
	emit_signal("moved")

func set_cleaned():
	dirt.hide()
