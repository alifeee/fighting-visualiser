# character script
# controls animations and death and such

extends AnimatedSprite2D

var time_start = 0
var time_now = 0

@export var particles2d: CPUParticles2D

# swap any actions from left to right/etc
@export var SWAP_ACTIONS: float = 1

# pixels to move sprite left/right on attack
@export var HIT_JUMP_PIXELS: float = 150
@export var HIT_JUMP_TIME: float = 0.1

# pixels to move sprite right/down upon death
@export var DEATH_RIGHTWARD_PIXELS: float = 0
@export var DEATH_DOWNWARD_PIXELS: float = 90
@export var DEATH_TIME: float = 0.2

# not used - for bobbing up and down
@export var OSCILLATE_AMPLITUDE: float = 10
@export var OSCILLATE_FREQ: float = 0.01
@export var OSCILLATE_OFFSET: float = 0

# hit anim
@export var FLASH_WHITE_TIME = 0.15
@export var BULGE_TIME = 0.15

var INITIAL_POSITION
var alive: bool = true

func _ready() -> void:
	time_start = Time.get_ticks_msec()
	INITIAL_POSITION = position
	reset()

func _process(delta: float) -> void:
	if alive:
		time_now = Time.get_ticks_msec()
		var time_elapsed = time_now - time_start
		#position.y = INITIAL_POSITION.y + OSCILLATE_AMPLITUDE * sin(time_elapsed * OSCILLATE_FREQ + OSCILLATE_OFFSET)

func reset():
	rotation = 0
	alive = true
	self.play("default")
	position = INITIAL_POSITION

func _on_reset():
	reset()

func _on_do_hit(health: Variant):
	var tween = get_tree().create_tween()
	tween.tween_property(
		self, "position:x",
		INITIAL_POSITION.x - (SWAP_ACTIONS * HIT_JUMP_PIXELS),
		HIT_JUMP_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self, "position:x", INITIAL_POSITION.x, HIT_JUMP_TIME
	).set_trans(Tween.TRANS_SINE)

func _on_hit(health: Variant) -> void:
	if not alive: return
	
	# animation
	self.frame = 0
	self.play("gethit")
	self.animation_finished.connect(
		func (): self.play("default")
	)
	
	# flash white
	var tween = get_tree().create_tween()
	tween.set_parallel().tween_property(
		self, "modulate:v", 1, FLASH_WHITE_TIME
	).from(15)
	# bulge
	tween.tween_property(
		self, "scale", scale, BULGE_TIME
	).from(scale * 1.2)
	
	# emit particles
	if particles2d:
		particles2d.emitting = true

func _on_die():
	# slow-mo on death
	# Globals.start_slow_motion(0.5)
	alive = false
	var tween = get_tree().create_tween()
	# rotate
	tween.tween_property(
		self, "rotation", SWAP_ACTIONS * PI/2, DEATH_TIME
	)
	tween.parallel().tween_property(
		self, "position:y", position.y + DEATH_DOWNWARD_PIXELS, DEATH_TIME
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(
		self, "position:x", position.x + DEATH_RIGHTWARD_PIXELS, DEATH_TIME
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(
		Globals.stop_slow_motion
	)
	self.stop()
