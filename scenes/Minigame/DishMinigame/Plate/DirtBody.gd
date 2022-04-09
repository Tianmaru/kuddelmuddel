extends RigidBody2D

signal overlap


onready var body_collision = $CollisionShape2D
onready var trigger_collision = $Trigger/CollisionShape2D

func set_enabled(enabled : bool):
	body_collision.set_deferred("disabled", not enabled)
	trigger_collision.set_deferred("disabled", not enabled)

func _on_Trigger_area_entered(area):
	emit_signal("overlap")
