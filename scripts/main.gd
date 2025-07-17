extends Node2D

var GAME_ACTIVE = false

@export var hideonstart: ColorRect
@export var health_unit = 1
@export var health_step = 2 # 

signal reset

var damage = 5
signal hit_left(health)
signal hit_right(health)

# automate pressing numbers 1-9,0
const set_health_actions = [1,2,3,4,5,6,7,8,9,10]
var set_health_inputs: Array[String]

func _init() -> void:
	for num in set_health_actions:
		set_health_inputs.append("set damage %s" % num)

func _ready() -> void:
	if hideonstart:
		hideonstart.visible = true
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		reset.emit()
	if Input.is_action_just_pressed("start"):
		start()
	if Input.is_action_just_pressed("hit left"):
		hit("left", damage)
	if Input.is_action_just_pressed("hit right"):
		hit("right", damage)
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
				hit("left", damage)
			else:
				hit("right", damage)

func hit(direction: String, hitdamage):
	if not GAME_ACTIVE:
		return
	if direction == "left":
		hit_left.emit(hitdamage)
	elif direction == "right":
		hit_left.emit(hitdamage)

func start():
	reset.emit()
	if hideonstart:
		hideonstart.visible = false
