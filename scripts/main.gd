extends Node2D

@export var health_unit = 1
@export var health_step = 2 # 

var damage = 5
signal hit_left(health)
signal hit_right(health)

# for camera shake
@export var camera: Camera2D
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
@export var decay = 3  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

# automate pressing numbers 1-9,0
const set_health_actions = [1,2,3,4,5,6,7,8,9,10]
var set_health_inputs: Array[String]

func _init() -> void:
	for num in set_health_actions:
		set_health_inputs.append("set damage %s" % num)

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		camshake()
	if Input.is_action_just_pressed("hit left"):
		print("just hit left")
		hit_left.emit(damage)
	if Input.is_action_just_pressed("hit right"):
		print("just hit right")
		hit_right.emit(damage)
	for i in range(len(set_health_actions)):
		if Input.is_action_just_pressed(set_health_inputs[i]):
			damage = (set_health_actions[i] * health_step) * health_unit
	
func _unhandled_input(event):
	# listening to InputEventScreenTouch here is pointless
	#   as phones send an InputEventMouseButton anyway
	if event is InputEventMouseButton:
		if event.pressed:
			var SCREEN_SIZE_X = get_viewport().get_visible_rect().size.x
			var PRESSED = event.position.x
			if PRESSED < SCREEN_SIZE_X/2:
				hit_left.emit(damage)
			else:
				hit_right.emit(damage)

func camshake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	camera.offset.x = max_offset.x * amount * randf_range(-1, 1)
	camera.offset.y = max_offset.y * amount * randf_range(-1, 1)

func _on_hit_(health):
	# health likely ranges from 1 to 20,
	#   so scale it to 0.05-1
	#   and scale that from 0.5 to 0.8
	trauma = 0.5 + ((health/20) * 0.30)
