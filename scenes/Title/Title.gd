extends Node

var main = preload("res://scenes/main/Main.tscn")
onready var button = $Control/VBoxContainer/CenterContainer/PlayButton
onready var anim = $Transition/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_PlayButton_button_down():
	button.disconnect("button_down", self, "_on_PlayButton_button_down")
	anim.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene_to(main)
