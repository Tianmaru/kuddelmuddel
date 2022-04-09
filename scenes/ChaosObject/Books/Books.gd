extends ClickChaos

onready var scattered = $Scattered

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _set_chaos_level(value):
	._set_chaos_level(value)
	if not scattered:
		return
	for child in scattered.get_children():
		child.hide()
	scattered.get_child(value).show()
