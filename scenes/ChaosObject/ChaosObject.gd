class_name ChaosObject
extends Spatial

signal activated

export(int) var MAX_CHAOS = 4

export(int) var chaos_level = 0 setget set_chaos_level

# Called when the node enters the scene tree for the first time.
func _ready():
	set_chaos_level(chaos_level)

func set_chaos_level(value: int):
	print(name, " is at chaos ", value)
	chaos_level = clamp(value, 0, MAX_CHAOS)
	_set_chaos_level(chaos_level)

func _set_chaos_level(value: int):
	pass

func increase_chaos():
	set_chaos_level(chaos_level + 1)

func decrease_chaos():
	set_chaos_level(chaos_level - 1)

func is_messy():
	return not chaos_level < MAX_CHAOS
