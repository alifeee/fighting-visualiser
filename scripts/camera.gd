extends Camera2D

# for camera shake
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
@export var decay = 3  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

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
