extends Node2D

@export var hideonstart: ColorRect
@export var greyscale_filter: ColorRect
@export var IntroSky: Sprite2D
@export var IntroSky_initialposition_y: float = 218.0
@export var IntroSkyBackground: ColorRect
@export var IntroSkyMenu: Control
@export var GameOverMenu: Control
@export var GameOverMenu_WinnerLabel: Label
@export var health_unit = 1
@export var health_step = 2 # 

var intro_tween: Tween
var gameover_tween: Tween

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
	_on_reset()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		reset.emit()
	if Input.is_action_just_pressed("start"):
		if Globals.GAME_STATE == Globals.GAME_PRE_INTRO:
			if hideonstart:
				hideonstart.visible = false
			Globals.GAME_STATE = Globals.GAME_INTRO_SCREEN
		elif Globals.GAME_STATE == Globals.GAME_INTRO_SCREEN:
			intro_tween = get_tree().create_tween()
			const INTRO_WIPE_DURATION = 1.5
			const INTRO_WIPE_Y_OFFSET = 600
			Globals.GAME_STATE = Globals.GAME_PLAYING
			intro_tween.tween_property(
				IntroSkyMenu, "modulate:a", 0.0, INTRO_WIPE_DURATION
			).set_trans(Tween.TRANS_EXPO ).set_ease(Tween.EASE_OUT)
			intro_tween.parallel().tween_property(
				IntroSky, "position:y", INTRO_WIPE_Y_OFFSET, INTRO_WIPE_DURATION
			).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
			intro_tween.parallel().tween_property(
				IntroSkyBackground, "color:a", 0, INTRO_WIPE_DURATION
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	if (
		Globals.GAME_STATE != Globals.GAME_PLAYING and 
		Globals.GAME_STATE != Globals.GAME_DEAD
	):
		return
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
	if Globals.GAME_STATE != Globals.GAME_PLAYING:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			var SCREEN_SIZE_X = get_viewport().get_visible_rect().size.x
			var PRESSED = event.position.x
			if PRESSED < SCREEN_SIZE_X/2:
				hit("left", damage)
			else:
				hit("right", damage)

func hit(direction: String, hitdamage):
	if direction == "left":
		hit_left.emit(hitdamage)
	elif direction == "right":
		hit_right.emit(hitdamage) 

func _on_reset() -> void:
	print("resset!")
	hideonstart.visible = true
	damage = 5
	set_greyscale(0.0)
	if intro_tween:
		intro_tween.kill()
	if gameover_tween:
		gameover_tween.kill()
	IntroSky.position.y = IntroSky_initialposition_y
	IntroSkyBackground.color.a = 1.0
	IntroSkyMenu.modulate.a = 1.0 
	GameOverMenu.modulate.a = 0.0
	Globals.GAME_STATE = Globals.GAME_PRE_INTRO

func _on_p1_death():
	if Globals.GAME_STATE == Globals.GAME_PLAYING:
		GameOverMenu_WinnerLabel.text = "PLAYER 2 WINS!"
	_on_death()

func _on_p2_death():
	if Globals.GAME_STATE == Globals.GAME_PLAYING:
		GameOverMenu_WinnerLabel.text = "PLAYER 1 WINS!"
	_on_death()

func _on_death():
	const GAMEOVER_WAIT_DURATION = 1.5
	const GAMEOVER_WIPE_DURATION = 1.5
	Globals.GAME_STATE = Globals.GAME_DEAD
	gameover_tween = get_tree().create_tween()
	gameover_tween.tween_property(
		(greyscale_filter.material as ShaderMaterial),
		"shader_parameter/onoff",
		1,
		GAMEOVER_WIPE_DURATION
	)
	gameover_tween.parallel().tween_interval(GAMEOVER_WAIT_DURATION)
	gameover_tween.tween_property(
		GameOverMenu, "modulate:a", 1.0, GAMEOVER_WIPE_DURATION
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
   
func set_greyscale(amt: float):
	(greyscale_filter.material as ShaderMaterial
	).set_shader_parameter("onoff", amt)
