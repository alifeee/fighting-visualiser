extends Node

const TEST_GLOBAL = "!hi"

func start_slow_motion(scale: float = 0.5) -> void:
	Engine.time_scale = scale
	AudioServer.playback_speed_scale = scale

func stop_slow_motion() -> void:
	Engine.time_scale = 1.0
	AudioServer.playback_speed_scale = 1.0
