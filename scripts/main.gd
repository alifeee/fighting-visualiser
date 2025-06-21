extends Node2D

signal hit_left(health)
signal hit_right(health)

@export var HIT_AMOUNT: float = 15

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hit left"):
		print("just hit left")
		hit_left.emit(HIT_AMOUNT)
	if Input.is_action_just_pressed("hit right"):
		print("just hit right")
		hit_right.emit(HIT_AMOUNT)

func _unhandled_input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			var SCREEN_SIZE_X = get_viewport().get_visible_rect().size.x
			var PRESSED = event.position.x
			if PRESSED < SCREEN_SIZE_X/2:
				hit_left.emit(HIT_AMOUNT)
			else:
				hit_right.emit(HIT_AMOUNT)
