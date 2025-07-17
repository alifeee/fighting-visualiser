extends Control

@export var FLASH_MS: float = 700
@export var flash_selection: Label
@export var flash_dotdotdot: Label

var time_start = 0
var time_now = 0

func _init():
	time_start = Time.get_ticks_msec()

func _process(delta: float) -> void:
	time_now = Time.get_ticks_msec()
	var on = int(time_now / FLASH_MS) % 2
	if on:
		flash_selection.text[0] = ">"
	else:
		flash_selection.text[0] = " "
