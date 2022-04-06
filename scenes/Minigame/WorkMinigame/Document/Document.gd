extends Area2D

export(bool) var approved = true setget set_approved
export(Texture) var texture_approved
export(Texture) var texture_rejected

onready var sprite = $Sprite

func _ready():
	update_texture()

func set_approved(value: bool):
	approved = value
	update_texture()

func update_texture():
	if approved:
		sprite.texture = texture_approved
	else:
		sprite.texture = texture_rejected
