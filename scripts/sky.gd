extends Sprite2D

const START = -25
const END = -760.0
const TRAVEL_TIME = 30
var tween

func tween_to_end():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(
		self, "position:x", END, TRAVEL_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(tween_to_start)

func tween_to_start():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(
		self, "position:x", START, TRAVEL_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(tween_to_end)
	
func _ready() -> void:
	tween_to_end()
