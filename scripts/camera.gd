extends Camera2D

# for death zoom
@export var p1: AnimatedSprite2D
@export var p2: AnimatedSprite2D
@export var DEATH_ZOOM_IN_TIME: float = 0.1
@export var DEATH_ZOOM_OUT_TIME: float = 0.2
# for camera shake
var trauma = 0.0 # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
## How quickly the shaking stops [0, 1].
@export var decay = 3
## Maximum hor/ver shake in pixels.
@export var max_offset = Vector2(50, 25)
## Maximum rotation in radians (use sparingly).
@export var max_roll = 0.1

var INITIAL_POSITION: Vector2
var INITIAL_ZOOM: Vector2

func _ready() -> void:
	INITIAL_POSITION = position
	INITIAL_ZOOM = zoom

func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		camshake()

func camshake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)

func _on_hit_(health):
	# health likely ranges from 1 to 20,
	#   so scale it to 0.05-1
	#   and scale that from 0.5 to 0.8
	trauma = 0.5 + ((health/20) * 0.30)

func _on_p1_die():
	zoom_to(p1)
func _on_p2_die():
	zoom_to(p2)

func zoom_to(player):
	print("zooming to %s" % player.position)
	print("camera position: %s" % position)
	var tween = get_tree().create_tween()
	tween.tween_property(
		self, "position", player.position, DEATH_ZOOM_IN_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(
		self, "zoom", Vector2(1.2,1.2), DEATH_ZOOM_IN_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# reset
	tween.tween_property(
		self, "position", INITIAL_POSITION, DEATH_ZOOM_OUT_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(
		self, "zoom", INITIAL_ZOOM, DEATH_ZOOM_OUT_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
