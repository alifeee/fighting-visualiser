extends Node

const TEST_GLOBAL = "!hi"

var GAME_STATE = GAME_PRE_INTRO
enum {
	GAME_PRE_INTRO,
	GAME_INTRO_SCREEN,
	GAME_PLAYING,
	GAME_DEAD
}

func start_slow_motion(scale: float = 0.5) -> void:
	Engine.time_scale = scale
	AudioServer.playback_speed_scale = scale

func stop_slow_motion() -> void:
	Engine.time_scale = 1.0
	AudioServer.playback_speed_scale = 1.0
