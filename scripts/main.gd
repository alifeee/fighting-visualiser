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
