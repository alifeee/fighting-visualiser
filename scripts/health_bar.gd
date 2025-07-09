@tool
extends Control

signal zeroed()

const FLASH_WHITE_TIME = 0.15
const BULGE_TIME = 0.15

@export var swap: bool = false
@export_range(0, 100, 0.01) var health: float = 100:
	set(new_value):
		health = new_value
		_on_health_changed(health)

var progressbar: ProgressBar
var dead: bool = false
	
func _ready() -> void:
	progressbar = $MarginContainer/ProgressBar
	if swap:
		progressbar.fill_mode = progressbar.FILL_END_TO_BEGIN
	else:
		progressbar.fill_mode = progressbar.FILL_BEGIN_TO_END
	progressbar.value = health

func _process(delta: float) -> void:
	progressbar.value = lerp(progressbar.value, health, 0.1)
	if progressbar.value <= 0 and not dead:
		dead = true
		zeroed.emit()

func _on_health_changed(health):
	# if progressbar:
	#	progressbar.value = health
	# do nothing - health bar continually follows health
	pass

func _on_hit(health: float) -> void:
	var tween = get_tree().create_tween()
	# flash white
	tween.set_parallel().tween_property(
		self, "modulate:v", 1, FLASH_WHITE_TIME
	).from(15)
	# bulge
	tween.tween_property(
		self, "scale", Vector2(1,1), BULGE_TIME
	).from(Vector2(1.1,1.1))
	self.health -= health
