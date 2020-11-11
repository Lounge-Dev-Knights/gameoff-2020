extends AudioStreamPlayer

const BASE_PITCH = 1
const MAX_PITCH = 15
const MAX_DURATION_PRESSED = 4.5

var PITCH_INCREASE_PER_S = (MAX_PITCH - BASE_PITCH) / (MAX_DURATION_PRESSED)

func adjust(_duration_charging):
	var pitch = BASE_PITCH + (_duration_charging * PITCH_INCREASE_PER_S)
	pitch_scale = pitch
	pitch_scale = clamp(pitch_scale, BASE_PITCH, MAX_PITCH)
