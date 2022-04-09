extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var minigame = $TrashMinigame

func _input_event(event):
	get_tree().set_input_as_handled()

func _unhandled_input(event):
	#get_tree().set_input_as_handled()
	pass
