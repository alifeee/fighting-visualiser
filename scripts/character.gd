# character script
# controls animations and death and such

extends AnimatedSprite2D

var time_start = 0
var time_now = 0
@export var OSCILLATE_AMPLITUDE: float = 10
@export var OSCILLATE_FREQ: float = 0.01
@export var OSCILLATE_OFFSET: float = 0
# hit anim
const FLASH_WHITE_TIME = 0.15
const BULGE_TIME = 0.15

var INITIAL_Y
var alive: bool = true

func _ready() -> void:
	time_start = Time.get_ticks_msec()
	INITIAL_Y = position.y
	if alive:
		self.play("default")

func _process(delta: float) -> void:
	if alive:
		time_now = Time.get_ticks_msec()
		var time_elapsed = time_now - time_start
		#position.y = INITIAL_Y + OSCILLATE_AMPLITUDE * sin(time_elapsed * OSCILLATE_FREQ + OSCILLATE_OFFSET)

func _on_hit(health: Variant) -> void:
	if not alive: return
	self.play("gethit")
	self.animation_finished.connect(
		func (): self.play("default")
	)
	var tween = get_tree().create_tween()
	# flash white
	tween.set_parallel().tween_property(
		self, "modulate:v", 1, FLASH_WHITE_TIME
	).from(15)
	# bulge
	tween.tween_property(
		self, "scale", scale, BULGE_TIME
	).from(scale * 1.1)

func _on_die():
	rotation += PI/2
	alive = false
	self.stop()
